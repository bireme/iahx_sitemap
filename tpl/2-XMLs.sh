#!/bin/bash
# ------------------------------------------------------------------------- #
# 2-XMLs.sh - Cria os XMLs
# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL                  COMENTARIO
# 20140310  Fabio Brito                  edicao original
# ------------------------------------------------------------------------- #

source ../tpl/getConfig.inc

# Funcao para verificacao do arquivo XML
chkxml () {
    tidy -q -f ERROR -w 0 -xml -o ${1}_ok ${1}
    rm -f ${1}; mv ${1}_ok ${1}

    if [ -s ERROR ] # file exists and is not empty
    then
        echo "   ERRO!!! XML ${1} com Problema!!!"
    fi
    cat ERROR; rm -fr ERROR
}


# Garantindo que nao serao utilizados arquivos XMLs de processamento antigo
ls | grep ".xml" > apagar.lst
if [ -s apagar.lst ]
then
    for i in `cat apagar.lst`
    do
        rm $i
    done
fi
[ -f apagar.lst ] && rm apagar.lst

# Variaveis
limitexml=50000
lastmod=`date +%Y-%m-%d`

# lista todos os arquivos ".id"
ls *.id > id_verifica.lst

# Verifica se todos os arquivos ID tem conteudo, se houver algum vazio nao fara parte da lista para processamento
for i in `cat id_verifica.lst`
do
    if [ `cat $i | wc -l` -gt 0 ]
    then
        echo $i >> id.lst
    else
        echo $i >> id_vazio.lst
    fi   
done

# echo "DEBUG 1"
# cat id.lst
# echo "DEBUG"

# Concerta ordem dos ID´s
for i in `cat id.lst`
do
    # echo "  Assegura que não existirão ocorrências de MEDLINE ou COCHRANE em ${i}"
    cat ${i} | grep -v "mdl-" | grep -v "coc-" > ${i}.tmp

    # echo "  Tentando ordenar ${i}"
    cat ${i}.tmp | sort -Vr > ${i}
    [ -f ${i}.tmp ] && rm ${i}.tmp
done


# echo "DEBUG 2"
# cat id.lst
# echo "DEBUG"



# Cria XMLs 
for i in `cat id.lst`
do

    # Calcular quantas linhas tem o arquivo .id
    nlinhas=`cat $i | wc -l`

    nome_FI=`echo ${i} | sed s/.id$//g`

    cont_arqs_xml=1

    # Criando diretorio para FI
    [ -d ${nome_FI} ] && rm -fr ${nome_FI}
    [ ! -d ${nome_FI} ] && mkdir ${nome_FI}

    echo "---------------------------------------------------------------------------------------------"
    echo "${nome_FI} - ${nlinhas} registros"

    # Variaveis setadas no inicio do processamento (URL_BVS_OPAC e INSTANCIA_BVS_OPAC)
    url_ID="${URL_LINK}/${BVS}/${resource_na_url}"

    if [ $nlinhas -gt $limitexml ]
        then

            echo " * FI com mais de 50000 ids, particionando arquivos"
            split -l ${limitexml} ${i} ${i}_

            for j in ${i}_*
            do
                echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                                    > $j.xml
                echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"               >> $j.xml

                # Le arquivo particionado e cria XML
                while read nid 
                do 
                    # Monta o XML 
                    echo "    <url>"                                                                >> $j.xml
                    echo "        <loc>${url_ID}/${nid}</loc>"                                      >> $j.xml
                    echo "        <lastmod>${lastmod}</lastmod>"                                    >> $j.xml
                    echo "        <changefreq>${changefreq}</changefreq>"                           >> $j.xml
                    echo "    </url>"                                                               >> $j.xml
                done < $j

                echo "</urlset>"                                                                    >> $j.xml

                # Nomeia XML
                mv $j.xml ${nome_FI}_${cont_arqs_xml}.xml

                # Checando arquivo XML
                chkxml ${nome_FI}_${cont_arqs_xml}.xml

                # Armazena no diretorio da FI
                mv ${nome_FI}_*.xml ${nome_FI}

                ((  cont_arqs_xml++  ))

                # Apagando arquivo utilizado
                rm $j

            done

        else

            echo " * Apenas 1 xml sera criado"

            echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                                       > unico.xml
            echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"                  >> unico.xml

               while read nid
               do
            
                   # Monta o XML
                   echo "    <url>"                                                                >> unico.xml
                   echo "        <loc>${url_ID}/${nid}</loc>"                                      >> unico.xml
                   echo "        <lastmod>${lastmod}</lastmod>"                                    >> unico.xml
                   echo "        <changefreq>${changefreq}</changefreq>"                           >> unico.xml
                   echo "    </url>"                                                               >> unico.xml

               done < $i
 
               echo "</urlset>"                                                                    >> unico.xml

               # Nomeia XML
               mv unico.xml ${nome_FI}_${cont_arqs_xml}.xml

               # Checando arquivo XML
               chkxml ${nome_FI}_${cont_arqs_xml}.xml

               # Armazena no diretorio da FI
               mv ${nome_FI}_${cont_arqs_xml}.xml ${nome_FI}

    fi

done


echo
echo "--> Criando arquivo Sitemap index para:"

# Cria diretorio para toda BVS
diretorio="${BVS}/"

# Cria lista com os diretorios para fazer index
ls -l | grep "^d" | awk {' print $9 '} > fi.lst

cat fi.lst
if [ `cat fi.lst | wc -l` -gt 1 ] 
# Quando existe mais que um diretorio eh porque esta rodando portal
# entao o processo de criacao dos diretorios e respectivamente a URL sera diferente
then
    for FI in `cat fi.lst`
    do

        cd ${FI}

        # lista todos os arquivos ".xml"
        ls -v *.xml > xmls.lst

        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                                    > ${FI}_Sitemap_index.xml
        echo "    <sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"     >> ${FI}_Sitemap_index.xml

        while read nome_xml
        do
            echo "        <sitemap>"                                                        >> ${FI}_Sitemap_index.xml
            echo "            <loc>${URL_LINK}/${diretorio}sitemap/${FI}/${nome_xml}</loc>" >> ${FI}_Sitemap_index.xml
            echo "            <lastmod>${lastmod}</lastmod>"                                >> ${FI}_Sitemap_index.xml
            echo "        </sitemap>"                                                       >> ${FI}_Sitemap_index.xml

        done < xmls.lst

        echo "    </sitemapindex>"                                                          >> ${FI}_Sitemap_index.xml

        # posicionando sitemap index

        # limpando area de trabalho
        [ -f xmls.lst ] && rm xmls.lst
        mv ${FI}_Sitemap_index.xml ..
        # Voltando para a proxima
        cd ..

    done

else

    # Quando existe somente 1 diretorio eh porque os dados veem de BVS entao nao existem subdiretorios
    for FI in `cat fi.lst`
    do

        cd ${FI}

        # lista todos os arquivos ".xml"
        ls -v *.xml > xmls.lst

        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                                    > ${FI}_Sitemap_index.xml
        echo "    <sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"     >> ${FI}_Sitemap_index.xml

        while read nome_xml
        do
            echo "        <sitemap>"                                                        >> ${FI}_Sitemap_index.xml
            echo "            <loc>${URL_LINK}/${diretorio}sitemap/${FI}/${nome_xml}</loc>" >> ${FI}_Sitemap_index.xml
            echo "            <lastmod>${lastmod}</lastmod>"                                >> ${FI}_Sitemap_index.xml
            echo "        </sitemap>"                                                       >> ${FI}_Sitemap_index.xml

        done < xmls.lst

        echo "    </sitemapindex>"                                                          >> ${FI}_Sitemap_index.xml

        # posicionando sitemap index

        # limpando area de trabalho
        [ -f xmls.lst ] && rm xmls.lst

        # Foi usado quando eu considerava que nao era necessario ter diretorio
        # mv *.xml ..

        mv ${FI}_Sitemap_index.xml ..
        # Voltando para a proxima
        cd ..

        # Foi usado quando eu considerava que nao era necessario ter diretorio
        # [ -d ${FI} ] && rm -fr ${FI}


    done

fi

# Mostra id que vieram vazio da coleta
if [ -d id_vazio.lst ]
then
    if [ `cat id_vazio.lst | wc -l` -gt 0 ]
    then
        echo
        echo "---------------------------------------------------------------------------------------------"
        echo " Arquivos sem conteudo:"
        cat id_vazio.lst
        echo
    fi
fi

# Guarda os arquivos ".id"
mv *.id ../ids

# Limpa area de trabalho
[ -f sitemap.lst ] && rm sitemap.lst
[ -f fi.lst ] && rm fi.lst
[ -f id_verifica.lst ] && rm id_verifica.lst
[ -f id.lst ] && rm id.lst
[ -f id_vazio.lst ] && rm id_vazio.lst

unset FI
unset changefreq
unset cont_arqs_xml
unset diretorio
unset i j
unset lastmod
unset limitexml
unset nlinhas
unset nome_FI
unset URL_LINK
unset url_ID

