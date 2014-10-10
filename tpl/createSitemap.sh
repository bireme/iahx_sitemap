#!/bin/bash
# ------------------------------------------------------------------------- #
# createSitemap.sh 
# ------------------------------------------------------------------------- #
#      Entrada: nome da BVS
#        Saida: arquivos xmls
#     Corrente: /bases/IAHX_Sitemaps/apps/wrk
#      Chamada: ../tpl/createSitemap.sh <BVS>
#      Exemplo: nohup ../tpl/createSitemap.sh regional &> ../out/proc.YYYYMMDD.out &
#     Objetivo: Coordenar processamento de coleta do arquivo JSON oriundo do solr
#               e criar xmls para a indexação do sitemaps do google
#  Comentarios:
#  Observacoes:
#
# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL                  COMENTARIO
# 20140225  Fabio Brito                  edicao original
# ------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${3} ${4} ${5}"
echo ""
# ------------------------------------------------------------------------- #

source ../tpl/getConfig.inc

# Verificao de arquivos essenciais
#---------------------------------
if [ ! -f ../tpl/1-IDs_full.py -o ! -f ../tpl/2-XMLs.sh ]
then
    echo "FATAL!!! Arquivos do processamento ausentes!"
    echo "Verificar: - /tpl/1-IDs_full.py"
    echo "           - /tpl/2-XMLs.sh"
    exit 0
fi

echo "--> Coletando Todos os IDs da BVS"
echo "python ../tpl/1-IDs_full.py ${BVS} ${URL_BVS}"
python ../tpl/1-IDs_full.py ${BVS} ${URL_BVS}

# echo "Saida forcada"
# exit 0

echo
echo "--> Criando XMLs..."
../tpl/2-XMLs.sh

# echo "Saida forcada"
# exit 0

# Cria diretorio para esse processamento. * se existe apaga e cria novamente

# Somente cria diretorio da FI no diretorio BVS se existir *_Sitemap_index.xml
cria=`ls *_Sitemap_index.xml | wc -l`
if [ $cria -gt 0 ]
then
    [ -d ../sitemap/${BVS} ] && rm -fr ../sitemap/${BVS}
    [ ! -d ../sitemap/${BVS} ] && mkdir ../sitemap/${BVS}
    mv * ../sitemap/${BVS}
else
    rm *
    echo "ERRO. Nao foi realizado a criacao dos XMLs"
fi

HORA_FIM=`date '+ %s'`
DURACAO=`expr ${HORA_FIM} - ${HORA_INICIO}`
HORAS=`expr ${DURACAO} / 60 / 60`
MINUTOS=`expr ${DURACAO} / 60 % 60`
SEGUNDOS=`expr ${DURACAO} % 60`

echo
echo "DURACAO DE PROCESSAMENTO"
echo "-------------------------------------------------------------------------"
echo " - Inicio:  ${HI}"
echo " - Termino: `date '+%Y.%m.%d %H:%M:%S'`"
echo
echo " Tempo de execucao: ${DURACAO} [s]"
echo " Ou ${HORAS}h ${MINUTOS}m ${SEGUNDOS}s"
echo

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Processa  ${0} ${1} ${3} ${4} ${5}"
# ------------------------------------------------------------------------- #
echo
echo


# Limpando area de trabalho
[ -d ../wrk ] && rm -fr ../wrk

unset DURACAO
unset HI
unset HOMOLOG
unset HORAS
unset HORA_FIM
unset HORA_INICIO
unset IDIDX
unset INDEX
unset INSTANCIA_BVS_OPAC
unset MINUTOS
unset NPORT
unset PATH_EXEC
unset PATH_IAHX
unset SEGUNDOS
unset URL_BVS
unset URL_BVS_OPAC
unset url_dir
unset cria
