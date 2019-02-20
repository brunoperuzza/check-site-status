#!/bin/bash

comunicarRocket() {

	HORARIO="$(date +"%T")"

	if [ -z ${EMOJI} ]; then
		EMOJI=":loud_sound:"
	fi

	if [ -z ${COLOR} ]; then
		COLOR="#764FA5"
	fi

	COMUNICACAO="${URL_ROCKETHOOK}/${ROCKETHOOK}"

	MENSAGEM="${HORARIO} - ${NOME_APLICACAO} - ${MENSAGEM_RESPOSTA} - ${URL_APLICACAO}"

	COMANDO="$(curl -X POST --data-urlencode 'payload={"icon_emoji":"'"${EMOJI}"'","attachments":[{"text":"'"${MENSAGEM}"'","color":"'"${COLOR}"'"}]}' ${COMUNICACAO})"
	echo -e ${COMANDO}
}

preencherArquivoResposta() {

	# Inicializando variável caso não tenha sido utilizada como parâmetro
	if [ ! ${QUANTIDADE_VERIFICACOES} ]; then
		QUANTIDADE_VERIFICACOES=1
	fi

	# Caso tenha repetido a comunicação anterior, soma no contador
	if [ ${RESPOSTA_STATUS_NUMERO} -eq ${ULTIMA_RESPOSTA_RECEBIDA} ]; then
		#TODO arrumar soma
		QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA=$(expr ${QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA} + 1)
	fi

	# Caso tenha conseguido se comunicar com o site, preenche a variável
	if [ ${QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA} -eq ${QUANTIDADE_VERIFICACOES} ]; then
		echo "${RESPOSTA_STATUS_NUMERO}
${RESPOSTA_STATUS_NUMERO}
${QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA}">${PATH_COMPLETO_ARQUIVO_RESULTADO}
		comunicarRocket
	else
		echo "${ULTIMA_RESPOSTA_ENVIADA}
${RESPOSTA_STATUS_NUMERO}
${QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA}">${PATH_COMPLETO_ARQUIVO_RESULTADO}
	fi
}

preencherArquivoRespostaPrimeiraExecucao() {

	echo "${RESPOSTA_STATUS_NUMERO}
${RESPOSTA_STATUS_NUMERO}
1">${PATH_COMPLETO_ARQUIVO_RESULTADO}
	comunicarRocket
}


primeiraExecucao() {

	MENSAGEM_RESPOSTA="Realizando configurações iniciais do script de verificação de status do site"
	COLOR="#0000FF"
	preencherArquivoRespostaPrimeiraExecucao
}

falhaComunicacao() {

	MENSAGEM_RESPOSTA="Falha de comunicação"
	COLOR="#FF0000"
	preencherArquivoResposta
}

conexaoReestabelecida() {

	MENSAGEM_RESPOSTA="Comunicação reestabelecida - Status ${RESPOSTA_STATUS_NUMERO}"
	COLOR="#00FF00"
	preencherArquivoResposta
}

verificarAlteracaoStatus() {

	MENSAGEM_RESPOSTA="Status alterado - ${ULTIMA_RESPOSTA_RECEBIDA} -> ${RESPOSTA_STATUS_NUMERO}"
	COLOR="#FFFF00"
	preencherArquivoResposta
}

verificarConexao() {

	PATH_COMPLETO_ARQUIVO_RESULTADO=${PATH_RESULTADO}/${NOME_APLICACAO}
	
	# Cria diretório caso necessário
	if [ ! -d "${PATH_RESULTADO}" ]; then
		mkdir ${PATH_RESULTADO}
	fi
	
	# Caso tenha uma resposta anterior, preenche as variáveis
	if [ -f "${PATH_COMPLETO_ARQUIVO_RESULTADO}" ]; then
		ULTIMA_RESPOSTA_ENVIADA=$(awk 'NR==1' ${PATH_COMPLETO_ARQUIVO_RESULTADO})
		ULTIMA_RESPOSTA_RECEBIDA=$(awk 'NR==1' ${PATH_COMPLETO_ARQUIVO_RESULTADO})
		QUANTIDADE_RESPOSTA_REPETIDA_SEGUIDA=$(awk 'NR==3' ${PATH_COMPLETO_ARQUIVO_RESULTADO})
	fi

	# Recebe a resposta da comunicação com o site
	RESPOSTA_COMUNICACAO=$(curl -Is ${URL_APLICACAO} | grep HTTP)

	# Inicializa a variável que será preenchida com o status do site
	RESPOSTA_STATUS_NUMERO=0

	# Caso tenha conseguido se comunicar com o site, preenche a variável
	if [ ${#RESPOSTA_COMUNICACAO} -ne 0 ]; then
		RESPOSTA_STATUS_NUMERO=$(echo ${RESPOSTA_COMUNICACAO} | cut -d " " -f 2)
	fi

	# Caso seja a primeira execução ou não exista arquivo de resultado anterior
	if [ ! ${ULTIMA_RESPOSTA_RECEBIDA} ]; then
		primeiraExecucao
	else
		# Caso não tenha conseguido comunicação com o site
		if [ ${RESPOSTA_STATUS_NUMERO} -eq 0 ]; then
			falhaComunicacao
		else
			if [ ${ULTIMA_RESPOSTA_RECEBIDA} -eq 0 ]; then
				conexaoReestabelecida
			else
				verificarAlteracaoStatus
			fi
		fi
	fi
}

##### Main

NOME_APLICACAO=$1
URL_APLICACAO=$2
URL_ROCKETHOOK=$3
ROCKETHOOK=$4
PATH_RESULTADO=$5
QUANTIDADE_VERIFICACOES=$6
EMOJI=$7

verificarConexao
