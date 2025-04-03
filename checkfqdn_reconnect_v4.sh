#!/bin/bash

# Dominio a verificar
CHECK_DOMAIN="https://exampledomain.com"

# Función para verificar el acceso a un dominio
can_access_domain() {
    curl -s --head --request GET "$CHECK_DOMAIN" | grep "200" > /dev/null
}

while true; do
    # Verificar si se puede acceder al dominio
    if ! can_access_domain; then
        echo "Cannot access $CHECK_DOMAIN. Reconnecting ProtonVPN..."

        # Desconectar de ProtonVPN
        protonvpn-cli d

        # Esperar unos segundos para asegurarse de que la desconexión sea efectiva
        sleep 5

        # Intentar conectar a una nueva ubicación aleatoria hasta que se pueda acceder al dominio
        while true; do
            protonvpn-cli c -r

            # Esperar unos segundos para que la conexión se establezca
            sleep 10

            # Verificar si se puede acceder al dominio
            if can_access_domain; then
                echo "Can access $CHECK_DOMAIN. Connection established."
                break
            else
                echo "Cannot access $CHECK_DOMAIN. Reconnecting again..."

                # Desconectar de ProtonVPN
                protonvpn-cli d

                # Esperar unos segundos antes de intentar reconectar
                sleep 5
            fi
        done
    else
        echo "Can access $CHECK_DOMAIN. No action needed."
    fi

    # Esperar 5 minutos (300 segundos) antes de la siguiente verificación
    sleep 30
done
