#!/bin/bash

acao=$1
arquivo=$2
pasta=$3


case "$acao" in
    -b | --backup)

        # Testa se tá tudo certo
        [ -z   $pasta ] && echo "ERRO: Diga o nome da pasta" && exit 1
        [ -z $arquivo ] && echo "ERRO: Diga o nome do arquivo" && exit 1
        [ ! -e $pasta ] && echo "ERRO: Arquivo ou pasta para backup não existe" && exit 1 
        [ -e $arquivo ] && echo "ERRO: Arquivo do backup já existe" && exit 1

        echo "Fazendo backup da pasta/arquivo $pasta para o arquivo $arquivo"
        tar -czf $arquivo $pasta 
        # Verifica se o backup foi concluído com sucesso
        if [ $? == 0 ]; then 
            echo "Backup Concluído"
        else
            echo "Erro ao fazer backup"
        fi
                ;;
    -r | --restaurar)
        # Testa se tá tudo certo
        [ -z $arquivo   ] && echo "ERRO: Diga o nome do arquivo" && exit 1 
        [ ! -e $arquivo ] && echo "ERRO: Arquivo para restaurar não existe" && exit 1
        
        echo "Restaurando backup de $arquivo"
        tar -xf $arquivo
        # Verifica se a restauração ocorreu com sucesso
        if [ $? == 0 ]; then
            echo "Restauração concluída"
        else
            echo "Erro na restauração"
        fi
        ;;
    *)
        echo "Sintaxe: $0 -[b/r] <arquivo> <pasta>"
        echo "-b | --backup    : Fazer Backup"
        echo "    <pasta>  : A pasta para que você quer fazer backup"
        echo "    <arquivo>: O arquivo que vai ser o backup"
        echo "-r | --restaurar : Restaurar um Backup"
        echo "    <arquivo>: O arquivo que você quer restaurar"
        ;;
esac

exit 0
