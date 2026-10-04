<!-- docqui: 2.8.0 | prompt: PROMPT_3A | atualizado: 2026-08-28 -->
---
id: VAL-ANA-05
feature_set: VAL-ANA
dominio: VAL
entidade: Inscrição
prioridade: P2
mvp: false
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01, VAL-ANA-03]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Editar Inscrição Validada
> **Nível 3** - Feature Set: Análise e Decisão — Domínio: Validação - `VAL-ANA-05`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador nacional corrigir os dados de uma inscrição que já foi validada — respostas do formulário, respostas do questionário, enquadramento, membros da equipe e anexos — mediante justificativa, guardando o estado antes e depois da correção para consulta posterior.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Justificativa | entrada do usuário | editável | texto longo | sim | não pode ficar em branco |
| Respostas do formulário | Inscrição | editável | conforme o campo do formulário | não | seguem as validações do próprio campo configurado |
| Respostas do questionário | Inscrição | editável | conforme a questão | não | seguem as validações da própria questão |
| Enquadramento | seleção → Enquadramento do tipo de participante | editável | lista de opções | não | apenas enquadramentos do tipo de participante da inscrição |
| Membros da equipe | Inscrição | editável | lista | não | respeita o mínimo e o máximo de membros da oferta |
| Anexos removidos | seleção → Documento da Inscrição | editável | lista | não | apenas anexos da própria inscrição |
| Anexos novos | entrada do usuário | editável | arquivo | não | seguem a configuração de anexos do tipo de participante |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Responsável pela edição | administrador autenticado | Ao salvar a edição |
| Data da edição | data e hora do salvamento | Ao salvar a edição |
| Retrato anterior | estado completo da inscrição antes da correção | Ao salvar a edição |
| Retrato posterior | estado completo da inscrição depois da correção | Ao salvar a edição |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Editar Inscrição Validada | EE | 3 | 11 | Alta | 6 | 2026-09-01 |

### Memória de cálculo

**Editar Inscrição Validada** — EE. Formas de lógica: 1 (situação Validada, justificativa obrigatória, validações do formulário e do questionário, mínimo e máximo de membros, configuração de anexos), 5, 6 (grava a inscrição corrigida e os dois retratos), 7, 12. Intenção primária: manter ALI.

```json
{"pe": "Editar Inscrição Validada",
 "alr": ["Inscrição", "Tipo de Participante", "Validação Inscrição"],
 "der": ["Justificativa", "Respostas do formulário", "Respostas do questionário", "Enquadramento", "Membros da equipe", "Anexos removidos", "Anexos novos", "Responsável pela edição", "Data da edição", "Mensagem", "Ação"]}
```
- **ALR (3)**: Inscrição *(respostas, membros, anexos e os dois retratos — subgrupos do mesmo ALI)* · Tipo de Participante *(as validações do formulário e do questionário, o enquadramento, a configuração de anexos e a de equipe)* · Validação Inscrição *(a situação Validada exigida pela regra 1)*.
- **DER (11)** — entrada (7): Justificativa · Respostas do formulário · Respostas do questionário · Enquadramento · Membros da equipe · Anexos removidos · Anexos novos. Saída (2): Responsável pela edição · Data da edição · Mensagem · Ação.
- **Fora da contagem**: os dois retratos da inscrição são gravados sem cruzar a fronteira — não são DER (CPM 5.5.5, atributos gerados dentro da fronteira).

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **6 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisões de produto (docqui) | Lotação confirmada | Confirmado que a edição administrativa acontece **dentro da tela de validação da inscrição** — a feature fica em `VAL-ANA` e não migra para `INS-PAR`. A superfície já registrada no N3 é a correta |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (edição administrativa de inscrição validada, com retratos antes/depois) — capacidade implementada e até então não especificada |

---

*Feature Set: Análise e Decisão · Domínio: Validação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
