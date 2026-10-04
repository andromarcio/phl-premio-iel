<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-02
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [INS-PAR-01]
origem:
  tipo: issue
  chave: HU-015_Inscricao_Participante
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

# Editar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-02`

## Descrição
Permite ao participante preencher e alterar os dados da inscrição em andamento — oferta, campos do formulário dinâmico, respostas do questionário e membros da equipe — com salvamento automático a cada alteração.

No formulário de inscrição, o participante percorre os capítulos pela barra lateral — como oferta, questionário e equipe —, informa ou altera os dados de cada um e acompanha o progresso; cada alteração é salva automaticamente, sem ação de salvar.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — a HU não numera critérios; realiza "Preencher Formulário de Inscrição": oferta, campos dinâmicos, questionário e membros da equipe, com salvamento automático a cada alteração e indicador de progresso, inclusive na inscrição aguardando ajuste |

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
Feature: Editar Inscrição

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Oferta | Oferta | entrada do usuário | editável | seleção → Oferta | sim | uma das ofertas configuradas para a premiação |
| Campo do formulário | Resposta de Formulário | entrada do usuário | editável | variável (conforme configuração) | conforme configuração | obrigatoriedade e formato definidos pela premiação |
| Resposta do questionário | Resposta de Questão | entrada do usuário | editável | texto ou seleção | conforme configuração | conforme a questão configurada (discursiva ou objetiva) |
| Identificação do participante | Inscrição | entrada do usuário | editável | texto | não | rótulo de identificação exibido na inscrição |
| Nome completo (membro) | Membro de Equipe da Inscrição | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: Nome de pessoa |
| CPF (membro) | Membro de Equipe da Inscrição | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: CPF |
| E-mail (membro) | Membro de Equipe da Inscrição | entrada do usuário | editável | texto | sim (por membro) | → ver FIELD-DICTIONARY: E-mail |
| Telefone (membro) | Membro de Equipe da Inscrição | entrada do usuário | editável | texto | não | → ver FIELD-DICTIONARY: Telefone |
| Gênero (membro) | Membro de Equipe da Inscrição | entrada do usuário | editável | lista | não | uma opção da lista de gêneros |
| Tipo de vínculo (membro) | Tipo de Vínculo de Membro | entrada do usuário | editável | seleção → Tipo de Vínculo de Membro | sim (por membro) | um dos tipos de vínculo configurados |

*Gênero (membro) aponta a entidade onde o valor é gravado. ⚠️ A origem das opções não está descrita: se vierem da lista do sistema de gêneros (HU-012), a Entidade passa a ser Item da Lista do Sistema — confirmar.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Percentual de preenchimento | Proporção dos itens obrigatórios preenchidos | A cada alteração de campo |
| Status | Em andamento | Quando o preenchimento começa a partir do rascunho |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Campo do Formulário | lê | Campos e obrigatoriedade definidos para a oferta escolhida (regras 3 e 4) |
| Questão de Avaliação | lê | Questões e obrigatoriedade do questionário da oferta (regras 3 e 4) |
| Configuração de Anexo | lê | Anexos exigidos pela oferta, que entram no percentual de preenchimento (regras 3 e 6) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Editar Inscrição | principal | EE | 2 | 27 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

**Editar Inscrição** — EE · ALR 2 · DER 27 · Complexo · 6 PF

```json
{"pe": "Editar Inscrição",
 "alr": ["Inscrição", "Tipo de Participante"],
 "der": ["Percentual Inscrição", "Qtd questões preenchidas/Total questões", "Título Questão Formulário de Inscrição", "Descrição Questão", "Obrigatoriedade questão", "Resposta (formulário)", "Número Questão Questionário de Avaliação", "Título Questão", "Tipo Questão", "Obrigatoriedade", "Peso", "Resposta (questionário)", "Qtd min membros equipe", "Qtd max membros equipe", "Qtd membros cadastrados", "Nome membro", "CPF", "E-mail", "Telefone", "Genero", "Tipo de validação do formulário", "Mensagem de validação", "Tipo Anexo", "Tipo Arquivo", "Arquivo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a transação grava as respostas do formulário e do questionário, os membros da equipe, a identificação e o percentual de preenchimento
2. `Tipo de Participante` — a configuração da oferta (campos, questões, limites da equipe, anexos exigidos e tipos de vínculo) que define o que é preenchido e o que é obrigatório

⚠️ A planilha repete o rótulo *Resposta*: uma vez entre os DER do formulário de inscrição e outra entre os do questionário de avaliação. Aqui está desambiguado por onde aparece — *Resposta (formulário)* e *Resposta (questionário)*, que se gravam em entidades distintas (*Resposta de Formulário* e *Resposta de Questão*). Se a equipe de métricas os tiver por um só DER, como pede o CPM para o mesmo campo, o DER cai para 26 sem mudar a complexidade; mantido como o baseline contou, a confirmar.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios cobertos da HU (sem numeração na fonte) na `## Origem`, coluna Entidade em `## Campos` (com o Preenchimento das seleções normalizado e o Tipo `seleção → X`), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON — com o DER repetido *Resposta* desambiguado —, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
