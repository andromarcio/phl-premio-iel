<!-- docqui: {{VERSION}} | prompt: {{PROMPT_ID}} | atualizado: {{YYYY-MM-DD}} -->
# MESSAGE-DICTIONARY.md
> Dicionário de **mensagens de UI** que a pessoa usuária lê — e o **baseline** de
> validação (obrigatório, formato, sucesso, estados de tela).
>
> Garante texto **literal e consistente** em todo o sistema. Nos cenários, escreva
> sempre o texto final do catálogo — nunca "conforme o Design System" (isso é
> gatilho de busca, não texto entregável).
>
> **Como referenciar nos N3**:
> - Mensagens genéricas (obrigatório/formato/sucesso): `# ← MESSAGE-DICTIONARY: BASELINE`
> - Mensagem específica: cite a chave e escreva o texto literal.
>
> **Precedência**: mensagem de campo canônico vem do **FIELD-DICTIONARY** (tem
> precedência sobre o baseline daqui).

---

## Baseline de validação

> Mensagens genéricas reutilizadas por qualquer campo/feature. Ajuste o texto ao
> tom de voz definido no N0. Use o marcador `# ← MESSAGE-DICTIONARY: BASELINE`
> nos cenários em vez de reescrevê-las.

| Chave | Situação | Texto literal |
|---|---|---|
| `REQUIRED` | Campo obrigatório não preenchido | "Campo obrigatório." |
| `INVALID_FORMAT` | Formato inválido (genérico) | "Formato inválido." |
| `MAX_LENGTH` | Excedeu o comprimento máximo | "Máximo de [N] caracteres." |
| `MIN_LENGTH` | Abaixo do comprimento mínimo | "Mínimo de [N] caracteres." |
| `SAVE_SUCCESS` | Registro salvo | "Registro salvo com sucesso." |
| `DELETE_SUCCESS` | Registro excluído | "Registro excluído com sucesso." |
| `DELETE_CONFIRM` | Confirmação antes de excluir | "Deseja realmente excluir este registro?" |
| `GENERIC_ERROR` | Falha inesperada | "Ocorreu um erro. Tente novamente." |
| `NO_PERMISSION` | Ação sem permissão | "Você não tem permissão para esta ação." |

---

## Estados de tela

> Textos padrão para os estados que toda tela de listagem/formulário pode assumir.

| Chave | Estado | Texto literal |
|---|---|---|
| `LOADING` | Carregando | "Carregando…" |
| `EMPTY` | Sem dados | "Nenhum registro encontrado." |
| `EMPTY_SEARCH` | Busca sem resultados | "Nenhum resultado para a busca." |
| `ERROR_STATE` | Falha ao carregar | "Não foi possível carregar os dados." |

---

## Mensagens específicas por domínio

> Uma seção por domínio. Crie conforme os N3 forem especificados. Use chaves
> descritivas em SCREAMING_SNAKE_CASE prefixadas pelo domínio.

### Configuração da Premiação

| Chave | Situação | Texto literal |
|---|---|---|
| `CFG_CATEGORIA_NOME_DUPLICADO` | Nome de categoria repetido no mesmo prêmio | "Já existe uma categoria com este nome neste prêmio." |
| `CFG_MODALIDADE_NOME_DUPLICADO` | Nome de modalidade repetido na mesma categoria | "Já existe uma modalidade com este nome nesta categoria." |
| `CFG_MODALIDADE_PERIODO_INVALIDO` | Período de inscrição com fim anterior ao início | "A data de fim das inscrições deve ser posterior à data de início." |
| `CFG_LISTA_CODIGO_DUPLICADO` | Código de lista repetido no sistema | "Já existe uma lista com este código." |
| `CFG_LISTA_SALVAR_ANTES_ITENS` | Tentativa de configurar itens antes de salvar a lista | "Salve a lista antes de salvar os itens." |
| `CFG_PREMIO_NOME_DUPLICADO` | Nome de prêmio repetido no sistema | "Já existe um prêmio com este nome." |
| `CFG_PREMIO_PERIODO_INVALIDO` | Data de término anterior à data de início | "A data de término deve ser igual ou posterior à data de início." |
| `CFG_LINK_TIPO_DUPLICADO` | Link público já emitido para o tipo de participante no prêmio | "Já existe um link público para este tipo de participante neste prêmio." |
| `CFG_LINK_TIPO_INCOMPLETO` | Tipo de participante sem formulário ou enquadramento configurado | "Configure o formulário e ao menos um enquadramento do tipo de participante antes de gerar o link." |
| `CFG_IMPORT_ARQUIVO_INVALIDO` | Planilha de importação em formato ou estrutura inválidos | "Arquivo inválido: verifique o formato e a estrutura da planilha." |

### Avaliação

| Chave | Situação | Texto literal |
|---|---|---|
| `AVL_ETAPA_PERIODO_INVALIDO` | Data de término da etapa anterior à de início | "Data de fim deve ser maior ou igual à data de início." |
| `AVL_ETAPA_SEM_PERFIL` | Etapa salva sem nenhum perfil autorizado | "Selecione pelo menos um perfil — etapa sem perfil autorizado não pode ser operada." |
| `AVL_ETAPA_LIMITE` | Tentativa de criar etapa além do limite de cinco | "Esta premiação já atingiu o limite de cinco etapas." |
| `AVL_ETAPA_FECHADA_EDICAO` | Tentativa de editar etapa na situação Fechada | "Etapa fechada não pode ser editada." |
| `AVL_ETAPA_LIBERACAO_INVALIDA` | Data de liberação do feedback anterior ao fim da etapa | "A data de liberação do feedback deve ser igual ou posterior à data de fim da etapa." |
| `AVL_ETAPA_CLASSIFICADOS_INVALIDO` | Quantidade de classificados ausente ou menor que um | "Informe ao menos 1 classificado por grupo." |
| `AVL_ETAPA_PREMIADOS_INVALIDO` | Quantidade de premiados informada menor que um | "A quantidade de premiados deve ser ao menos 1. Deixe em branco se a etapa não premia." |
| `AVL_ETAPA_CORTE_BLOQUEADO` | Alteração dos cortes com a etapa fechada | "Os cortes desta etapa já foram aplicados no resultado. Reabra a etapa para alterá-los." |
| `AVL_REORDENACAO_BLOQUEADA` | Reordenar etapas com ao menos uma etapa fechada | "Há etapas já fechadas nesta premiação. Reordenar etapas agora invalidaria a cadeia de aprovações dos participantes." |
| `AVL_CRITERIOS_BLOQUEADO` | Alterar critérios de desempate durante a janela de fechamento | "Não é possível alterar critérios de desempate: existe etapa com prazo encerrado em fase de fechamento." |
| `AVL_CRITERIOS_SEM_TIPO` | Premiação sem tipos de participante ao configurar critérios | "Esta premiação ainda não tem tipos de participante vinculados. Adicione modalidades e tipos de participante antes de configurar critérios de desempate." |
| `AVL_REMOCAO_AVALIADOR_BLOQUEADA` | Remoção de avaliador do pool com avaliações ativas | "Não é possível remover o avaliador: há avaliações em andamento ou finalizadas." |
| `AVL_LOGIN_DUPLICADO` | Login já existente no cadastro corporativo | "Este login já existe no cadastro corporativo. Utilize a busca de avaliadores existentes." |
| `AVL_ACEITE_CONFIRMACAO_OBRIGATORIA` | Aceite sem confirmar a leitura do termo | "Confirme a leitura do termo para continuar." |
| `AVL_TERMO_PENDENTE` | Acesso às avaliações bloqueado por termo pendente | "Aceite o termo de confidencialidade para acessar as avaliações desta premiação." |
| `AVL_FINALIZACAO_INCOMPLETA` | Finalização com questões sem nota | "Pontue todas as questões antes de finalizar a avaliação." |
| `AVL_PARECER_MINIMO` | Parecer abaixo do mínimo na finalização | "O parecer deve ter no mínimo 50 caracteres." |
| `AVL_ETAPA_FECHADA` | Finalização com a etapa encerrada | "A etapa foi encerrada; a avaliação não pode mais ser finalizada." |
| `AVL_REABERTURA_ETAPA_FECHADA` | Reabertura com a etapa não aberta | "A etapa precisa estar aberta para reabrir a avaliação." |
| `AVL_CONSOLIDACAO_ESTADO_FECHADO` | Alteração do feedback consolidado com o estado já fechado na etapa | "O estado já foi fechado; o feedback consolidado não pode mais ser alterado." |
| `AVL_FECHAMENTO_PENDENCIAS` | Fechamento de estado com inscrições sem feedback consolidado | "Este estado ainda tem inscrições sem feedback consolidado. Resolva as pendências antes de fechar." |
| `AVL_REABERTURA_ETAPA_POSTERIOR` | Reabertura de estado com etapa posterior da premiação já encerrada ⚠️ *(mensagem nova — proposta em 2026-09-01, aguardando aprovação)* | "Há etapa posterior já encerrada nesta premiação. Reabra as etapas seguintes antes de reabrir este estado." |
| `AVL_FECHAMENTO_EMPATE_CORTE` | Fechamento de estado com empate na linha de corte | "Há empate na linha de corte deste estado. Resolva o desempate antes de fechar." |
| `AVL_SEM_PENDENTES` | Salto para a próxima avaliação pendente sem nenhuma avaliação restante no recorte vigente | "Não há mais avaliações pendentes." |

---

## Como adicionar uma mensagem

1. Use o **baseline** sempre que a mensagem for genérica — não crie variações desnecessárias.
2. Mensagem nova e específica: adicione à seção do domínio com chave e texto literal.
3. Mensagem de **campo canônico**: defina no FIELD-DICTIONARY, não aqui.

---

## Instrução para a LLM

Ao escrever cenários/telas em um N3:
1. Use o **texto literal** do catálogo — nunca "conforme o Design System".
2. Para obrigatório/formato/sucesso genéricos, use `# ← MESSAGE-DICTIONARY: BASELINE`.
3. Mensagem de campo canônico vem do FIELD-DICTIONARY (precedência).
4. Mensagem inexistente no catálogo: proponha com ⚠️, aguarde aprovação e instrua a adição aqui.

> **Usado em (não escreva à mão)**: a seção `## Usado em (índice reverso)` ao final
> é **gerada** por `scripts/generate-usage-index.mjs` a partir das referências
> `→ ver`/`←` dos N3. Não edite à mão — rode o gerador (o CI valida que está fresco).

<!-- usado-em:gerado -->
## Usado em (índice reverso)

> Gerado por `scripts/generate-usage-index.mjs` a partir das referências `→ ver`/`←` nos N3. **Não editar à mão.**

| Entrada | Usado em |
|---|---|
| `AVL_ACEITE_CONFIRMACAO_OBRIGATORIA` | `AVL-AVA-02` |
| `AVL_CONSOLIDACAO_ESTADO_FECHADO` | `AVL-PAI-03` |
| `AVL_CRITERIOS_BLOQUEADO` | `AVL-ETA-06` |
| `AVL_CRITERIOS_SEM_TIPO` | `AVL-ETA-06` |
| `AVL_ETAPA_CLASSIFICADOS_INVALIDO` | `AVL-ETA-02` · `AVL-ETA-03` |
| `AVL_ETAPA_CORTE_BLOQUEADO` | `AVL-ETA-03` |
| `AVL_ETAPA_FECHADA` | `AVL-AVA-04` |
| `AVL_ETAPA_FECHADA_EDICAO` | `AVL-ETA-03` |
| `AVL_ETAPA_LIBERACAO_INVALIDA` | `AVL-ETA-02` · `AVL-ETA-03` |
| `AVL_ETAPA_LIMITE` | `AVL-ETA-02` |
| `AVL_ETAPA_PERIODO_INVALIDO` | `AVL-ETA-02` |
| `AVL_ETAPA_PREMIADOS_INVALIDO` | `AVL-ETA-02` · `AVL-ETA-03` |
| `AVL_ETAPA_SEM_PERFIL` | `AVL-ETA-02` · `AVL-ETA-03` |
| `AVL_FECHAMENTO_EMPATE_CORTE` | `AVL-APU-03` |
| `AVL_FECHAMENTO_PENDENCIAS` | `AVL-APU-03` |
| `AVL_FINALIZACAO_INCOMPLETA` | `AVL-AVA-04` |
| `AVL_LOGIN_DUPLICADO` | `AVL-ALO-03` |
| `AVL_PARECER_MINIMO` | `AVL-AVA-04` |
| `AVL_REABERTURA_ETAPA_FECHADA` | `AVL-AVA-05` |
| `AVL_REABERTURA_ETAPA_POSTERIOR` | `AVL-APU-12` |
| `AVL_REMOCAO_AVALIADOR_BLOQUEADA` | `AVL-ALO-02` |
| `AVL_REORDENACAO_BLOQUEADA` | `AVL-ETA-05` |
| `AVL_SEM_PENDENTES` | `AVL-AVA-04` |
| `AVL_TERMO_PENDENTE` | `AVL-AVA-03` |
| `BASELINE` | `ACS-ACE-01` · `ACS-ACE-02` · `ACS-ACE-03` · `ACS-ADM-01` · `ACS-ADM-02` · `ACS-ADM-03` · `ACS-ADM-04` · `ACS-AUD-01` · `AVL-ALO-01` · `AVL-ALO-02` · `AVL-ALO-03` · `AVL-ALO-04` · `AVL-ALO-05` · `AVL-ALO-06` · `AVL-ALO-07` · `AVL-APU-01` · `AVL-APU-02` · `AVL-APU-03` · `AVL-APU-04` · `AVL-APU-05` · `AVL-APU-06` · `AVL-APU-08` · `AVL-APU-09` · `AVL-APU-10` · `AVL-APU-12` · `AVL-APU-13` · `AVL-APU-14` · `AVL-AVA-01` · `AVL-AVA-02` · `AVL-AVA-03` · `AVL-AVA-04` · `AVL-AVA-05` · `AVL-AVA-06` · `AVL-AVA-07` · `AVL-ETA-01` · `AVL-ETA-02` · `AVL-ETA-03` · `AVL-ETA-04` · `AVL-ETA-05` · `AVL-ETA-06` · `AVL-ETA-07` · `AVL-PAI-01` · `AVL-PAI-02` · `AVL-PAI-03` · `AVL-PAI-04` · `CFG-CAT-01` · `CFG-CAT-02` · `CFG-CAT-03` · `CFG-CAT-05` · `CFG-EMA-01` · `CFG-EMA-02` · `CFG-LIS-01` · `CFG-LIS-02` · `CFG-LIS-03` · `CFG-LIS-04` · `CFG-LIS-05` · `CFG-MOD-01` · `CFG-MOD-02` · `CFG-MOD-03` · `CFG-MOD-05` · `CFG-PRE-01` · `CFG-PRE-02` · `CFG-PRE-03` · `CFG-PRE-04` · `CFG-PRE-05` · `CFG-PRE-06` · `CFG-PRE-07` · `CFG-PRE-08` · `CFG-PRE-09` · `CFG-PRE-10` · `CFG-PRE-11` · `CFG-PRE-12` · `CFG-PRE-13` · `CFG-TIP-01` · `CFG-TIP-02` · `CFG-TIP-03` · `CFG-TIP-05` · `CFG-TIP-06` · `CFG-TIP-07` · `CFG-TIP-08` · `CFG-TIP-09` · `CFG-TIP-10` · `CFG-TIP-11` · `CFG-TIP-12` · `CFG-TIP-13` · `CFG-TIP-14` · `CFG-TIP-15` · `CFG-TIP-16` · `CFG-VIN-01` · `CFG-VIN-02` · `CFG-VIN-03` · `CFG-VIN-04` · `CFG-VIN-05` · `CFG-VIN-06` · `CFG-VIN-07` · `CFG-VIN-08` · `CFG-VIN-09` · `CFG-VIN-10` · `CFG-VIN-11` · `INS-ACO-01` · `INS-ACO-02` · `INS-NOT-01` · `INS-NOT-02` · `INS-PAR-01` · `INS-PAR-02` · `INS-PAR-03` · `INS-PAR-04` · `INS-PAR-05` · `INS-PAR-06` · `INS-PAR-07` · `INS-PAR-08` · `VAL-AJU-01` · `VAL-AJU-02` · `VAL-AJU-03` · `VAL-AJU-04` · `VAL-ANA-01` · `VAL-ANA-02` · `VAL-ANA-03` · `VAL-ANA-04` · `VAL-ANA-05` · `VAL-ANA-06` · `VAL-FIL-01` · `VAL-FIL-02` · `VAL-FIL-03` |
| `CFG_ANEXO_SEM_EXTENSAO` | `CFG-TIP-12` |
| `CFG_ANEXO_TAMANHO_INTERVALO` | `CFG-TIP-12` |
| `CFG_CATEGORIA_NOME_DUPLICADO` | `CFG-CAT-02` · `CFG-CAT-03` |
| `CFG_ENQUADRAMENTO_NOME_DUPLICADO` | `CFG-TIP-10` |
| `CFG_IMPORT_ARQUIVO_INVALIDO` | `CFG-PRE-06` |
| `CFG_IMPORTACAO_ARQUIVO_INVALIDO` | `CFG-TIP-16` |
| `CFG_LINK_TIPO_DUPLICADO` | `CFG-PRE-07` |
| `CFG_LISTA_CODIGO_DUPLICADO` | `CFG-LIS-02` · `CFG-LIS-03` |
| `CFG_LISTA_SALVAR_ANTES_ITENS` | `CFG-LIS-05` |
| `CFG_MODALIDADE_NOME_DUPLICADO` | `CFG-MOD-02` · `CFG-MOD-03` |
| `CFG_MODALIDADE_PERIODO_INVALIDO` | `CFG-MOD-02` · `CFG-MOD-03` |
| `CFG_PREMIO_NOME_DUPLICADO` | `CFG-PRE-02` · `CFG-PRE-03` |
| `INS_ANEXO_EXTENSAO_INVALIDA` | `INS-PAR-05` |
| `INS_ANEXO_TAMANHO_EXCEDIDO` | `INS-PAR-05` |
| `INS_FINALIZACAO_PENDENCIAS` | `INS-PAR-03` |
| `INS_TOKEN_INVALIDO` | `INS-PAR-01` |
| `MAX_LENGTH` | `AVL-APU-02` |
| `MIN_LENGTH` | `AVL-APU-02` |
<!-- /usado-em -->
