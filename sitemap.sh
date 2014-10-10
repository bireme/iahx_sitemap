# Ativando virtualenv
../../IAHX_Sitemaps/bin/activate
# Garantindo existencia de diretorios de trabalho
[ ! -d sitemap ] && mkdir sitemap
[ ! -d wrk ] && mkdir wrk
[ ! -d ids ] && mkdir ids
# Acessando diretorio de trabalho e chamada inicial
cd wrk
../tpl/createSitemap.sh
