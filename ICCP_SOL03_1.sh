#!/bin/bash

argumento=$1

case "$argumento" in
    -pd)
        pstree
        ;;
    -pe)
        ps -x -o pid,etime,command
        ;;
    -pa)
        ps -aux
        ;;
    *)
        modelo=$(cat /proc/cpuinfo | grep "model name" | tail -1 | cut -d ":" -f 2)
        velocidade=$(cat /proc/cpuinfo | grep "cpu MHz" | tail -1 | cut -d ":" -f 2)
        cache=$(cat /proc/cpuinfo | grep "cache size" | tail -1 | cut -d ":" -f 2)

        echo "╭CPU:"
        echo "├──Modelo do CPU:$modelo"
        echo "├──Velocidade do CPU:$velocidade MHz"
        echo "╰──Tamanho do cache L3:$cache"

        echo

        echo "╭DISCOS"
        for disk in /sys/block/sd*; do
            disco="/dev/$(echo $disk | cut -d '/' -f 4-)"
            capacidade_disco=$(lsblk --output SIZE -n -d $disco)
            echo "├─Disco: $disco"
            echo "├──Tamanho do disco: $capacidade_disco"

            for partition in $disco*; do
                espaco_usado=$(lsblk --output FSUSED -n -d $partition)
                if [ ${#espaco_usado} != 0 ]; then
                    echo "├──Espaço usado na partição $partition: $espaco_usado"
                fi
            done
        done

        tamanho_dir_atual=$(df -h . | awk '{print $3}' | tail -1)
        echo "╰Tamanho do diretório atual: ($PWD) $tamanho_dir_atual"

        echo

        echo "╭REDE"
        echo "├─Nome do equipamento: $(hostname)"

        rotas=$(ip r | awk '/default/ {print $3}' | tail -1)
        echo "├─Endereço da rede: $rotas"


        ip=$(ip r | awk '/default/ {print $9}' | tail -1)
        mask=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')
        echo "├─Endereço de ip: $ip"
        echo "╰─Máscara de rede: $mask"  

        echo


        echo "╭PROCESSOS"
        echo "├─Execute $0 -pd para ver os processos com suas dependências"
        echo "├─Execute $0 -pe para ver os processos com seu tempo de execução"
        echo "├─Execute $0 -pa para ver todos os os seus processos"
        echo "╰─Processos ativos no terminal:"
        ps -o pid,command | sed "1d"

esac


exit 0


