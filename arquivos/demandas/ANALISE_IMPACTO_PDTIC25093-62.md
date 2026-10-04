<!-- docqui: 2.23.0 | prompt: analise-impacto | atualizado: 2026-10-04 -->
# Análise Impacto PDTIC25093-62

---

## Sumário

| Indicador | Valor |
|---|---|
| Features alteradas | 0 |
| Features novas | 0 |
| Processos elementares com contagem no baseline | 0 |
| Regras de negócio acrescentadas | +0 |
| Cenários acrescentados | +0 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **0 · 0** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**. Os N3 foram escritos por engenharia reversa entre **2026-08-25 e 27** e conferidos com o código em **2026-08-28** — logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. ⚠️ **O item não está entregue**: em 2026-10-01 o board o mostra como *In Progress*, aberto desde 2026-07-23. Esta análise é, portanto, do **pedido como está escrito**, não de entrega conferida. ⚠️ Os repositórios de código não estão ao alcance desta sessão (só o repositório de documentação), então nada aqui foi verificado contra o código.

---

## 1. Detalhe do item

**`PDTIC25093-62` — Favicon**

Na spec: **nenhuma feature alterada ou incluída**. O pedido é *"alterar favicon do sistema"* — a troca de um **ativo visual**, não de uma capacidade. Nenhum processo elementar muda de lógica, nenhum arquivo lógico ganha ou perde campo, e nada no comportamento observável pelo usuário se altera além da imagem na aba do navegador.

O único comentário do card, de 2026-09-24, é a pergunta sobre qual imagem usar — confirma que o que está em disputa é o arquivo, não o comportamento.

⚠️ **Há uma ambiguidade que decide se o item vale zero ou vale uma feature**, e ela não se resolve pelo texto do card. O sistema **já tem favicon configurável por premiação**: o campo `URL do favicon` (`DS_FAVICON_URL`, `nvarchar(500)`) existe no ALI **Premiação**, subgrupo Branding, e é carregado por `CFG-PRE-13` — Carregar Imagem de Configuração. "Favicon do sistema" pode querer dizer (a) o ícone fixo da aplicação Angular, que é ativo de build, ou (b) um valor novo para o campo que já existe. Em nenhuma das duas há função nova; a diferença é só onde o arquivo é trocado.

---

## 2. Alterações aplicadas na spec, por Feature Set

**Nenhuma.** Não há N3 a alterar nem a criar.

**Total do item: 0 features · +0 regras · +0 cenários · 0 PFB · 0 PFL.**

---

## 3. Tabelas alteradas, por função de dados

**Nenhuma alteração de modelo.** O campo `DS_FAVICON_URL` já existe no ALI **Premiação** desde o baseline; trocar o valor de um campo não altera a função de dados.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 0 PE | — | 0 | 0 |
| Funções de dados — 0 ALI | — | 0 | 0 |
| **Apurável do item** | — | **0** | **0** |

O zero tem motivo, e ele é o do próprio `global/SIZING.md` → *Regras de medição de serviços, item 5*: mudança **puramente técnica**, que não altera a lógica de processamento sob a ótica do usuário, não gera nova contagem. Trocar um ícone é o caso de manual dessa regra.

---

## 4. Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.**

---

## 5. Decisões de produto pendentes

> **O resumo de entrega da Sprint 6, recebido em 2026-10-04, não menciona o favicon** — nenhuma das cinco funcionalidades da sprint o alcança, e nenhuma das duas migrações toca o campo `DS_FAVICON_URL`. Isso confirma, por uma segunda fonte, que o item segue sem entrega, e as duas decisões abaixo continuam abertas nos mesmos termos. Ver `ANALISE_IMPACTO_SP06.md`.

### 1. O favicon a trocar é o da aplicação ou o da premiação?

O card diz "do sistema", e o sistema tem os dois. **O que trava**: nada da contagem — zero nos dois casos. Trava a **execução**: se for o da aplicação, é ativo no repositório do frontend e não passa por tela nenhuma; se for o da premiação, é a configuração de branding de uma edição e quem troca é o Administrador Nacional, por `CFG-PRE-13` — Carregar Imagem de Configuração, sem desenvolvimento. Confirmar antes de abrir trabalho de dev para algo que pode ser configuração.

### 2. Se a intenção for um favicon único para todo o sistema, o campo por premiação continua valendo?

**O que trava**: a especificação de `CFG-PRE-13` — Carregar Imagem de Configuração e o campo `URL do favicon` do ALI **Premiação**. Um favicon fixo de aplicação e um favicon por edição são regras concorrentes — se o fixo passar a mandar, o campo por premiação vira configuração sem efeito, e isso precisa sair da spec em vez de ficar documentado como se funcionasse.

---

## Metodologia

Card lido no Jira em 2026-10-02 (`sistemaindustria.atlassian.net`, board `PDTIC25093`). Confrontado com `global/data-models/configuracao.md`, `global/CONTAGEM-PF.md`, `global/SIZING.md` e `modules/INDEX.md`. Sem acesso aos repositórios de código nesta sessão.

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Conferido contra a entrega | O resumo de entrega da Sprint 6 não menciona o favicon, em nenhuma das cinco funcionalidades nem nas duas migrações — segunda fonte confirmando que o item não foi entregue. Nada muda na análise: segue **0 PFB · 0 PFL**, com as duas decisões abertas |
| 2026-10-02 | Análise de impacto (docqui) | Documento criado | Análise do card `PDTIC25093-62` — Favicon. Item sem impacto em feature ou função de dados; zero PF por ser mudança puramente técnica. Duas decisões de produto registradas, ambas sobre **onde** o favicon é trocado |
