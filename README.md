# Script para verificar status de sites

## Como utilizar:
- Escolha uma máquina para executar o script de verificação de status do site (sugestão: ambiente de testes da equipe)
Crie o arquivo que conterá o script para ser executado, `{pathCompletoScript}.sh`, e copie o conteúdo do anexo `rocketBotCheckSiteStatus.sh` como seu conteúdo.

- Junto com o script crie um diretório para armazenar as respostas obtidas ao tentar comunicação com o site, `{pathCompletoDiretorioRespostas}`.

- Utilize o comando `sudo crontab -e`.

  - `{cron}` - Tempo para execução do bot. `*/1 * * * *` executará a cada minuto. Ferramenta para auxiliar criação do cron - https://crontab.guru/;

  - `{nomeAplicacao}` - Nome que aparecerá na mensagem do Rocket, o qual deve ser único para cada path `{pathCompletoDiretorioRespostas}`;

  - `{urlAplicacao}` - URL que será utilizada para verificação de status;
  
  - `{urlRocketHooks}` - URL dos hooks do Rocket a ser comunicado;

  - `{rocketHook}` - Hook do canal que será enviada a comunicação - Solicitar ao administrador do Rocket;
  
  - `{quantidadeVerificacoes}` - Quantidade que o mesmo evento deve repetir para enviar comunicação ao Rocket;

  - `{emoji}` - Emoji a ser utilizado como avatar no Rocket;

  - Insira a linha `{cron} sh {pathCompletoScript} {nomeAplicacao} {urlAplicacao} {urlRocketHooks} {rocketHook} {pathCompletoDiretorioRespostas} {quantidadeVerificacoes} {emoji}`

## Exemplo de utilização:

`*/1 * * * * sh /var/application/bots/rocketBotCheckSiteStatus.sh LDI_Automatizado_Producao http://monitoramento.semas.pa.gov.br/ldi-automatizado/versao https://rocket.ti.lemaf.ufla.br/hooks dKbevuFrBBtqzRawm/fG34DdxYE3xhayqBQCTCNeRqzcSjCfEP9wRjXanYCyXx3KwF /var/application/bots/respostas_comunicacao/runners2 5 :smile:`

Não esqueça de salvar o arquivo após inserção da linha.


## Versões:

A versão atual é v0.2, na qual ainda podem ocorrer inconsistências.
