#!/bin/bash

testarHook() {

	HORARIO="$(date +"%T")"
	MENSAGEM_TESTE_COMUNICACAO="Teste de hook de comunicação com o Rocket"

	if [ -z ${EMOJI} ]; then
		EMOJI=":loud_sound:"
	fi

	if [ -z ${COLOR} ]; then
		COLOR="#764FA5"
	fi

	COMUNICACAO="${URL_ROCKETHOOK}/${ROCKETHOOK}"

	MENSAGEM="${HORARIO} - ${NOME_APLICACAO} - ${MENSAGEM_TESTE_COMUNICACAO}"

	COMANDO="$(curl -X POST --data-urlencode 'payload={"icon_emoji":"'"${EMOJI}"'","attachments":[{"text":"'"${MENSAGEM}"'","color":"'"${COLOR}"'"}]}' ${COMUNICACAO})"
	echo -e ${COMANDO}
}

##### Main

URL_ROCKETHOOK=$1
ROCKETHOOK=$2
EMOJI=$3

testarHook
