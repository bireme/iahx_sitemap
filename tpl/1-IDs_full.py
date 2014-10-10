#!/usr/bin/python
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------- #
# 1-IDs_full.py - Coleta todos os ID´s da BVS independente de base
# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL                  COMENTARIO
# 20140818  Fabio Brito                  edicao original
# ------------------------------------------------------------------------- #


import requests
import sys

# Verificando passagem de parametro
def main(argv):
    if len(argv) < 2:
        sys.stderr.write("Usage: %s <database>" % (argv[0],))
        print ""
        return 1

# Variaveis
FI = sys.argv[1]
URL_BVS = sys.argv[2]
print '    + %s' % FI

# Monta URL para pesquisa do total
parte_dois = 'select/?q=*'
parte_quatro = '&rows=0&wt=json'
URL_t = '%s%s%s' % (URL_BVS,parte_dois,parte_quatro)

# Executado consulta
r_t = requests.get(URL_t)

# Armazenando conteudo em 'data_t'
data_t = r_t.json()

# Lendo conteudo numFound e guardando em total_FI
total_FI = data_t['response']['numFound']

print ' Total de registros: ', total_FI

extensao = '.id'
nome_arq = '%s%s' % (FI,extensao)

# Abrindo novo arquivo para gravacao
outfile = open(nome_arq, 'a')

COUNT = 0
while (COUNT <= total_FI ):
    print '+ ', COUNT

    # Montando URL para coleta
    fixo_1 = 'select/?q=*'
    fixo_2 = '&start='
    fixo_3 = '&rows=1000&wt=json'
    URL = '%s%s%s%s%s' % (URL_BVS,fixo_1,fixo_2,COUNT,fixo_3)

    # print URL

    # Executando consulta
    r_range = requests.get(URL)

    # Armazenando conteudo em 'data_d'
    data_d = r_range.json()

    # Lendo conteudo da chave 'response' e guardando em data_d
    data_d = data_d['response']['docs']

    # Lendo todos os ID´s e gravando em arquivo
    for item in data_d:
        item = item.get('id')
        outfile.write(str(item)+'\n')

    COUNT = COUNT + 1000

# Fechando arquivo
outfile.close()

if __name__ == "__main__":
    sys.exit(main(sys.argv))
