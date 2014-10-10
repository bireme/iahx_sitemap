#!/bin/bash
# Configuracoes e variaveis
# -------------------------

# Exemplo de um link criado para sitemap
# http://pesquisa.bvsalud.org/bvsms/resource/pt/oai-bvs-ms-ms-36571
# \_________________________/ \___/ \_________/ \_________________/
#         URL_LINK             BVS resource_na_url  ID do documento


# URL_LINK - URL do Solr iahx
export URL_BVS="http://db02dx.bireme.br:8981/bvsms-main/"

# URL_LINK - URL da BVS
export URL_LINK="http://pesquisa.bvsalud.org"

# Acromino da BVS ou nome do diretorio em uso
# Exemplo: para http://pesquisa.bvsalud.org/bvsms
export BVS="bvsms"

# Frequencia de atualizacao
export changefreq="weekly"

# resource_na_url - Forma url correta para o registro configurando o resource
# Depende da versao do iahx
# export resource_na_url="resources"
export resource_na_url="resource/pt"

