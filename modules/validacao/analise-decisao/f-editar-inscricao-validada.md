<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-05
feature_set: VAL-ANA
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01, VAL-ANA-03]
origem:
  tipo: issue
  chave: PDTIC25093-68
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Editar Inscrição Validada
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-05`

## Descrição
Permite ao administrador nacional corrigir os dados de uma inscrição que já foi validada — respostas do formulário, respostas do questionário, enquadramento, membros da equipe e anexos — mediante justificativa, guardando o estado antes e depois da correção para consulta posterior.

No Detalhe da Inscrição validada, o administrador nacional abre o painel de edição, corrige o que for preciso — como respostas do formulário, membros da equipe e anexos —, preenche a justificativa e salva.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-68`](../../../analise-impacto/AIM-PDTIC25093-68.md) | Criação | — edição administrativa da inscrição já validada, com justificativa e os retratos antes e depois; o ticket trouxe a correção dos dados dos membros da equipe e a inclusão do primeiro membro quando a equipe está vazia |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), painel de edição administrativa *(confirmado em 2026-09-01: a edição administrativa mora dentro da tela de validação da inscrição, no Feature Set Análise e Decisão, e não no domínio Inscrição)*

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. Somente a inscrição na situação Validada pode ser editada pelo administrador.
2. A edição administrativa exige justificativa preenchida.
3. A edição administrativa não altera a situação da inscrição.
4. Cada edição administrativa guarda dois retratos da inscrição — o estado imediatamente anterior e o estado resultante —, ambos vinculados ao mesmo registro de histórico.
5. A edição administrativa dispensa as restrições de prazo e de situação que valem para a edição feita pelo participante. → ver `INS-PAR-02` (Editar Inscrição)
6. A edição administrativa é registrada com o responsável, a data e a justificativa.

---

## Cenários

```gherkin
Feature: Editar Inscrição Validada

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Corrigir uma resposta do formulário após a validação
    Given que a inscrição está na situação Validada
    When corrijo uma resposta do formulário e informo a justificativa
    Then a correção é gravada, a inscrição permanece Validada e o histórico registra a edição com a justificativa

  Scenario: Trocar um anexo após a validação
    Given que a inscrição está na situação Validada
    When removo um anexo, envio outro em seu lugar e informo a justificativa
    Then o anexo antigo deixa de constar da inscrição, o novo passa a constar e ambos os estados ficam guardados no histórico

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Editar sem justificativa
    Given que a inscrição está na situação Validada
    When tento salvar a edição sem preencher a justificativa
    Then o sistema não grava a correção e informa que a justificativa é obrigatória

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Editar inscrição que ainda não foi validada
    Given que a inscrição está na situação Em Validação
    When tento editar a inscrição como administrador
    Then o sistema informa que apenas inscrições validadas podem ser editadas por esse caminho

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador regional tenta editar
    Given que estou autenticado como Administrador Regional
    When tento editar uma inscrição validada
    Then o sistema nega a operação
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Justificativa | Histórico da Inscrição | entrada do usuário | editável | texto longo | sim | não pode ficar em branco |
| Respostas do formulário | Resposta de Formulário | entrada do usuário | editável | conforme o campo do formulário | não | seguem as validações do próprio campo configurado |
| Respostas do questionário | Resposta de Questão | entrada do usuário | editável | conforme a questão | não | seguem as validações da própria questão |
| Enquadramento | Enquadramento | entrada do usuário | editável | seleção → Enquadramento | não | lista de opções; apenas enquadramentos do tipo de participante da inscrição |
| Membros da equipe | Membro de Equipe da Inscrição | entrada do usuário | editável | lista | não | respeita o mínimo e o máximo de membros da oferta |
| Anexos removidos | Documento da Inscrição | entrada do usuário | editável | seleção → Documento da Inscrição | não | lista; apenas anexos da própria inscrição |
| Anexos novos | Documento da Inscrição | entrada do usuário | editável | arquivo | não | seguem a configuração de anexos do tipo de participante |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Responsável pela edição | administrador autenticado | Ao salvar a edição |
| Data da edição | data e hora do salvamento | Ao salvar a edição |
| Retrato anterior | estado completo da inscrição antes da correção | Ao salvar a edição |
| Retrato posterior | estado completo da inscrição depois da correção | Ao salvar a edição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê e grava | Só a inscrição Validada pode ser editada, a situação não muda e o enquadramento escolhido é gravado nela (regras 1 e 3) |
| Snapshot da Inscrição | grava | Guarda o retrato anterior e o posterior da inscrição, ambos vinculados ao mesmo registro de histórico (regra 4; campos automáticos) |
| Tipo de Participante | lê | As respostas seguem as validações dos campos do formulário e das questões, os anexos a configuração de anexos e a equipe o mínimo e o máximo de membros da oferta — configurações do tipo de participante (coluna Validação de `## Campos`; ALR da memória de cálculo) |
| Validação de Inscrição | lê | A edição exige a inscrição validada (regra 1; ALR da memória de cálculo) |

---

## Comportamento de tela

### Onde fica
Painel de edição aberto a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), disponível apenas quando a inscrição está Validada. O painel reapresenta o formulário, o questionário, o enquadramento, a equipe e os anexos em modo editável, com o campo de justificativa no rodapé.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão de salvar desabilitado com indicador enquanto a edição é gravada |
| Erro de validação | Destaca a justificativa vazia e os campos que violam a configuração do formulário |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Fecha o painel, atualiza o detalhe e acrescenta a edição ao histórico da inscrição |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição Validada é corrigida sem mudar de situação | cenário "Corrigir uma resposta do formulário após a validação" |
| SC-02 | Toda edição administrativa tem justificativa registrada | cenário "Editar sem justificativa" |
| SC-03 | Toda edição administrativa deixa o estado anterior e o posterior disponíveis para consulta | cenário "Trocar um anexo após a validação" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Editar Inscrição Validada | principal | EE | 3 | 11 | Alta | 6 | 2026-09-01 |

### Memória de cálculo

**Editar Inscrição Validada** — EE · ALR 3 · DER 11 · Alta · 6 PF

```json
{"pe": "Editar Inscrição Validada",
 "alr": ["Inscrição", "Tipo de Participante", "Validação Inscrição"],
 "der": ["Justificativa", "Respostas do formulário", "Respostas do questionário", "Enquadramento", "Membros da equipe", "Anexos removidos", "Anexos novos", "Responsável pela edição", "Data da edição", "Mensagem", "Ação"]}
```

Por que cada ALR:
1. `Inscrição` — a transação grava as respostas, os membros, os anexos e os dois retratos da inscrição (subgrupos do mesmo arquivo lógico)
2. `Tipo de Participante` — lê as validações do formulário e do questionário, o enquadramento, a configuração de anexos e a de equipe
3. `Validação Inscrição` — lê a situação Validada exigida pela regra 1

Formas de lógica: 1 (situação Validada, justificativa obrigatória, validações do formulário e do questionário, mínimo e máximo de membros, configuração de anexos), 5, 6 (grava a inscrição corrigida e os dois retratos), 7, 12. Intenção primária: manter ALI.

DER (11) — entrada (7): Justificativa · Respostas do formulário · Respostas do questionário · Enquadramento · Membros da equipe · Anexos removidos · Anexos novos; saída (2): Responsável pela edição · Data da edição; mais Mensagem e Ação.

Fora da contagem: os dois retratos da inscrição são gravados sem cruzar a fronteira — não são DER (CPM 5.5.5, atributos gerados dentro da fronteira).

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios do ticket na `## Origem` (o ticket não numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos` (o Preenchimento, que trazia o nome da entidade ou a seleção, passa a `entrada do usuário`, e a seleção vai para o Tipo), `## Dados lidos e gravados`, coluna Papel e memória de cálculo com o cabeçalho do processo elementar no formato da 4.1.0, o bloco JSON seguido do porquê de cada ALR e as explicações anteriores preservadas em prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **6 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisões de produto (docqui) | Lotação confirmada | Confirmado que a edição administrativa acontece **dentro da tela de validação da inscrição** — a feature fica em `VAL-ANA` e não migra para `INS-PAR`. A superfície já registrada no N3 é a correta |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (edição administrativa de inscrição validada, com retratos antes/depois) — capacidade implementada e até então não especificada |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
