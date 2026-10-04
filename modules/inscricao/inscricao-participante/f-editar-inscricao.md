---
id: INS-PAR-02
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
prioridade: P1
mvp: true
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [INS-PAR-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Editar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Domínio: Inscrição - `INS-PAR-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao participante preencher e alterar os dados da inscrição em andamento — oferta, campos do formulário dinâmico, respostas do questionário e membros da equipe — com salvamento automático a cada alteração.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/inscricao/formulario/:inscricaoId` (Formulário de Inscrição em capítulos, com salvamento automático e indicador de progresso).

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A edição só é possível enquanto a inscrição está em um estado editável pelo participante: rascunho, em andamento ou aguardando ajuste.
2. Cada alteração de campo é persistida automaticamente, sem depender de uma ação explícita de salvar.
3. A oferta escolhida (combinação de tipo de participante, modalidade e categoria) determina os campos, as questões e os anexos exigidos da inscrição.
4. A obrigatoriedade de cada campo e de cada questão da inscrição é a definida na configuração da premiação para a oferta selecionada.
5. Os membros da equipe só integram a inscrição quando a oferta permite inscrição em equipe.
6. O percentual de preenchimento reflete a proporção dos itens obrigatórios já preenchidos na inscrição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Preencher campos do formulário com salvamento automático
  Given que estou preenchendo uma inscrição em andamento
  When altero o valor de um campo do formulário
  Then o sistema persiste a alteração automaticamente
  And o percentual de preenchimento é recalculado

Scenario: Selecionar a oferta da inscrição
  Given que a inscrição admite mais de uma oferta
  When seleciono a oferta desejada
  Then o sistema apresenta o formulário, o questionário e os anexos correspondentes à oferta

Scenario: Cadastrar membro da equipe
  Given que a oferta permite inscrição em equipe
  When informo nome, CPF, e-mail e tipo de vínculo de um membro
  Then o sistema registra o membro na equipe da inscrição

# ── Erros de validação ─────────────────────────────────────────

Scenario: CPF de membro inválido
  Given que estou cadastrando um membro da equipe
  When informo um CPF inválido
  Then o sistema não registra o membro e exibe "Formato inválido."

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Inscrição em estado não editável
  Given que a inscrição já foi finalizada e está em validação
  When tento alterar os dados da inscrição
  Then o sistema não permite a edição e mantém os dados inalterados
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Oferta | seleção → Oferta | editável | seleção | sim | uma das ofertas configuradas para a premiação |
| Campo do formulário | entrada do usuário | editável | variável (conforme configuração) | conforme configuração | obrigatoriedade e formato definidos pela premiação |
| Resposta do questionário | entrada do usuário | editável | texto ou seleção | conforme configuração | conforme a questão configurada (discursiva ou objetiva) |
| Identificação do participante | entrada do usuário | editável | texto | não | rótulo de identificação exibido na inscrição |
| Nome completo (membro) | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: Nome de pessoa |
| CPF (membro) | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: CPF |
| E-mail (membro) | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: E-mail |
| Telefone (membro) | entrada do usuário | editável | texto | não | → ver FIELD-DICTIONARY: Telefone |
| Gênero (membro) | entrada do usuário | editável | lista | não | uma opção da lista de gêneros |
| Tipo de vínculo (membro) | seleção → Tipo de Vínculo | editável | seleção | sim (por membro) | um dos tipos de vínculo configurados |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Percentual de preenchimento | Proporção dos itens obrigatórios preenchidos | A cada alteração de campo |
| Status | Em andamento | Quando o preenchimento começa a partir do rascunho |

---

## Comportamento de tela

### Onde fica
Formulário de inscrição em `/inscricao/formulario/:inscricaoId`, organizado em capítulos (oferta, campos do formulário, questionário, anexos, equipe e revisão) com navegação lateral, indicador de progresso geral e marcadores de conclusão por capítulo.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera a inscrição em andamento |
| Erro de validação | Destaca o campo com a mensagem correspondente (ex.: "Campo obrigatório." ou "Formato inválido.") |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Confirma o salvamento automático de cada alteração |
| Empty state | Capítulo ainda não iniciado: marcador de pendente e campos vazios |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Cada alteração de campo é persistida automaticamente e o percentual de preenchimento é atualizado | Critério de aceite (HU-015): salvamento automático a cada alteração |
| SC-02 | A oferta selecionada determina o formulário, o questionário e os anexos apresentados | cenário "Selecionar a oferta da inscrição" |
| SC-03 | Membros de equipe são registrados apenas quando a oferta permite equipe | cenário "Cadastrar membro da equipe" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Editar Inscrição | EE | 2 | 27 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Editar Inscrição** — ALR (2): Inscrição · Tipo de Participante. DER (27): Percentual Inscrição · Qtd questões preenchidas/Total questões · Título Questão Formulário de Inscrição · Descrição Questão · Obrigatoriedade questão · Resposta · Número Questão Questionário de Avaliação · Título Questão · Tipo Questão · Obrigatoriedade · Peso · Resposta · Qtd min membros equipe · Qtd max membros equipe · Qtd membros cadastrados · Nome membro · CPF · E-mail · Telefone · Genero · Tipo de validação do formulário · Mensagem de validação · Tipo Anexo · Tipo Arquivo · Arquivo · Ação · Mensagem.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Domínio: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
