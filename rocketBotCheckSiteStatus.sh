#!/bin/bash

comunicarRocket() {

	HORARIO="$(date +"%T")"

	if [ -z $EMOJI ]; then
		EMOJI=":loud_sound:"
	fi

	if [ -z $COLOR ]; then
		COLOR="#764FA5"
	fi

	COMUNICACAO="https://rocket.ti.lemaf.ufla.br/hooks/$ROCKETHOOK"

	MENSAGEM="${HORARIO} - ${NOME_APLICACAO} - ${MENSAGEM_RESPOSTA} - ${URL_APLICACAO}"

	COMANDO="$(curl -X POST --data-urlencode 'payload={"icon_emoji":"'"$EMOJI"'","attachments":[{"text":"'"$MENSAGEM"'","color":"'"$COLOR"'"}]}' $COMUNICACAO)"
	echo -e $COMANDO
}

verificarConexao() {
	ULTIMA_RESPOSTA=$(cat $PATH_RESULTADO/$NOME_APLICACAO)
	RESPOSTA_COMUNICACAO=$(curl -Is $URL_APLICACAO | grep HTTP)

	if [ ${#RESPOSTA_COMUNICACAO} -ne 0 ]; then
		RESPOSTA_STATUS_NUMERO=$(echo $RESPOSTA_COMUNICACAO | cut -d " " -f 2)

		if [ ${ULTIMA_RESPOSTA} ]; then
			if [ ${RESPOSTA_STATUS_NUMERO} -ne ${ULTIMA_RESPOSTA} ]; then
				MENSAGEM_RESPOSTA="Status alterado - ${ULTIMA_RESPOSTA} -> ${RESPOSTA_STATUS_NUMERO}"
				COLOR="#FFFF00"
				echo ${RESPOSTA_STATUS_NUMERO}>$PATH_RESULTADO/$NOME_APLICACAO
				comunicarRocket
			fi
		else
			MENSAGEM_RESPOSTA="Comunicação reestabelecida - Status ${RESPOSTA_STATUS_NUMERO}"
			COLOR="#00FF00"
			echo ${RESPOSTA_STATUS_NUMERO}>$PATH_RESULTADO/$NOME_APLICACAO
			comunicarRocket
		fi
	else
		if [ ${ULTIMA_RESPOSTA} ]; then
			MENSAGEM_RESPOSTA="Falha de comunicação"
			COLOR="#FF0000"
			echo >$PATH_RESULTADO/$NOME_APLICACAO
			comunicarRocket
		fi
	fi
}

##### Main

NOME_APLICACAO=$1
URL_APLICACAO=$2
ROCKETHOOK=$3
PATH_RESULTADO=$4
EMOJI=$5

verificarConexao
