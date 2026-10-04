<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-03
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-AVA-02"]
origem:
  tipo: issue
  chave: HU-028_Avaliar_Inscricao
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

# Avaliar Inscrição
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-03`

## Descrição
Permite ao avaliador atribuir a nota de 1 a 5 de cada questão do questionário e registrar o parecer individual da inscrição que lhe foi designada, salvando a pontuação progressivamente.

No Painel do Avaliador, o avaliador aciona "Iniciar" ou "Continuar" no cartão da inscrição, consulta os dados e os anexos do participante, escolhe a nota de 1 a 5 de cada questão e escreve o parecer.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-028_Avaliar_Inscricao`](../../../hus/HU-028_Avaliar_Inscricao.docx) | Criação | — funcionalidade *Avaliar Inscrição* da HU: nota de 1 a 5 por questão salva a cada clique, parecer individual, dados da inscrição com o modo confidencial e download dos anexos |
| [`PDTIC25093-61`](../../../analise-impacto/AIM-PDTIC25093-61.md) | Alteração | — download do anexo pelo link individual de cada documento, com o direito conferido a cada acesso contra a inscrição designada ao avaliador |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao/:alocacaoId` (Avaliação da Inscrição): dados da inscrição, anexos, pontuação por questão e parecer.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/avaliacao-projetos/flow.html`

---

</div>

## Regras de negócio

1. A escala de notas é de 1 a 5 inclusive, com uma nota por questão do questionário.
2. Cada nota é registrada individualmente por questão, e a pontuação pode ser feita em sessões distintas.
3. Ao registrar a primeira nota da inscrição, o status da avaliação passa de A iniciar para Em andamento.
4. O parecer do avaliador é insumo confidencial da banca e não é divulgado ao participante na forma original.
5. O avaliador não tem acesso às notas nem aos pareceres atribuídos por outros avaliadores à mesma inscrição.
6. Em inscrição confidencial, ficam ocultos a identificação do participante, as respostas informadas e a equipe; os anexos e as questões permanecem acessíveis à avaliação.
7. A média do avaliador na inscrição é ponderada pelos pesos das questões configuradas no questionário.
8. Enquanto o termo ativo da premiação estiver pendente de aceite, a avaliação da inscrição fica indisponível ao avaliador.
9. Cada documento anexado à inscrição tem um identificador público próprio, distinto do identificador interno do registro, e é por esse identificador que o download do anexo é pedido.
10. O download de um anexo só é concedido a quem tem direito à inscrição a que ele pertence; para o avaliador, esse direito é a alocação vigente na inscrição.

---

## Cenários

```gherkin
Feature: Avaliar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Atribuir nota a uma questão
    Given que abro uma inscrição designada a mim
    When atribuo uma nota de 1 a 5 a uma questão
    Then o sistema registra a nota e coloca a avaliação em Em andamento na primeira nota registrada

  Scenario: Pontuar em sessões distintas
    Given que já registrei parte das notas em uma sessão anterior
    When retomo a avaliação da inscrição
    Then o sistema preserva as notas já registradas

  Scenario: Baixar anexo da inscrição designada
    Given que a inscrição designada a mim tem documentos anexados
    When peço o download de um anexo
    Then o sistema entrega o documento pelo link individual desse anexo

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inscrição confidencial
    Given que a inscrição é confidencial
    When avalio a inscrição
    Then o sistema oculta a identificação do participante e mantém os anexos e as questões acessíveis

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Anexo de inscrição não designada
    Given que tenho o link de um anexo de uma inscrição que não me foi designada
    When peço o download desse anexo
    Then o sistema nega o download e exibe "Você não tem permissão para esta ação."

  Scenario: Termo de confidencialidade pendente
    Given que ainda não aceitei o termo ativo da premiação
    When tento avaliar uma inscrição da premiação
    Then o sistema impede o acesso à inscrição e exibe "Aceite o termo de confidencialidade para acessar as avaliações desta premiação."
    # ← MESSAGE-DICTIONARY: AVL_TERMO_PENDENTE
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nota por questão | Nota de Avaliação | entrada do usuário | editável | seleção (1 a 5) | sim para finalizar | uma nota por questão; escala de 1 a 5 |
| Parecer do avaliador | Avaliação de Inscrição | entrada do usuário | editável | texto longo | sim para finalizar | mínimo de 50 caracteres não-brancos; registrado na finalização |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status da avaliação | Em andamento | Ao registrar a primeira nota da inscrição |
| Início da avaliação | Data e hora | Ao registrar a primeira nota da inscrição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê | Dados do participante, respostas do formulário e equipe da inscrição designada, com a ocultação do modo confidencial (regra 6) |
| Documento da Inscrição | lê | Cada anexo é pedido pelo identificador público do documento, e o download confere o direito do avaliador à inscrição (regras 9 e 10) |
| Questionário | lê | O questionário de avaliação do tipo de participante, que define as questões a pontuar na inscrição (regra 1) |
| Questão de Avaliação | lê | Enunciado e peso de cada questão do questionário, base da nota e da média ponderada (regras 1 e 7) |
| Histórico de Avaliação | lê e grava | Exibe a linha do tempo da própria avaliação e recebe a transição de A iniciar para Em andamento na primeira nota (regra 3) |
| Aceite do Termo de Confidencialidade | lê | Confere se o avaliador já aceitou o termo ativo da premiação antes de liberar a inscrição (regra 8) |
| Premiação | lê | O modo confidencial da premiação decide o que fica oculto (regra 6); a tela também mostra o nome da premiação |
| Alocação de Avaliadores | lê | A alocação do avaliador ao grupo da inscrição na etapa (ALR do baseline na consulta que abre a tela) |
| Tipo de Participante | lê | Tipo de participante do enquadramento, cujo questionário a inscrição responde (ALR do baseline) |
| Modalidade | lê | Modalidade do enquadramento exibida nos dados da inscrição (ALR do baseline) |
| Categoria | lê | Categoria do enquadramento exibida nos dados da inscrição (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao/:alocacaoId` (Avaliação da Inscrição): os dados da inscrição (respeitada a confidencialidade), os anexos — cada um baixado por seu próprio link individual —, a lista de questões com a seleção de nota, o campo de parecer, o progresso próprio e o histórico da própria avaliação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a inscrição é recuperada |
| Erro de validação | Sinaliza a questão sem nota ao tentar finalizar |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Confirma o registro de cada nota atribuída |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Cada nota de 1 a 5 é registrada por questão e a primeira nota coloca a avaliação em Em andamento | Regra de negócio (HU-028) |
| SC-02 | Em inscrição confidencial, a identificação do participante fica oculta e os anexos permanecem acessíveis | cenário "Inscrição confidencial" |
| SC-03 | O anexo é baixado pelo link individual do documento e o download é negado a quem não tem direito à inscrição | cenário "Anexo de inscrição não designada" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Avaliação (implícita) | acessório | SE | 7 | 31 | Complexo | 7 | 2026-02-28 |
| Avaliar Inscrição | principal | EE | 1 | 5 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Salvar Avaliação*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Avaliação (implícita)** — SE · ALR 7 · DER 31 · Complexo · 7 PF

```json
{"pe": "Consultar Avaliação (implícita)",
 "alr": ["Alocação Avaliadores", "Avaliação de Inscrição", "Premiação", "Inscrição", "Modalidade", "Categoria", "Tipo de Participante"],
 "der": ["Etapa", "Status", "Num projeto", "Premiação", "Organização", "Cidade / UF", "E-mail", "Categoria", "Modalidade", "Tipo de Participante", "Média Ponderada", "Nota (resumo)", "Qtd questões/total pontuadas", "Percentual questões pontuadas", "Prazo", "Qtd avaliadores", "Confidencialidade", "Anexos", "Número questão", "Peso", "Questão", "Resposta Questão", "Quantidade estrelas", "Nota (por questão)", "Feedback geral", "Nome Avaliador (Outros avaliadores)", "Data início/fim avaliação", "Status avaliação", "Transição avaliação (Histórico)", "Data/hora transição", "Avaliador"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — a alocação do avaliador ao grupo da inscrição na etapa
2. `Avaliação de Inscrição` — o status, as notas já registradas, o parecer e o histórico da própria avaliação, além do andamento dos demais avaliadores da inscrição
3. `Premiação` — o nome da premiação, a etapa com o prazo e o modo confidencial
4. `Inscrição` — os dados do participante, as respostas do formulário e os anexos
5. `Modalidade` — a modalidade do enquadramento da inscrição
6. `Categoria` — a categoria do enquadramento da inscrição
7. `Tipo de Participante` — o tipo de participante do enquadramento e o questionário de avaliação dele, com o enunciado e o peso de cada questão

⚠️ *Nota* aparece duas vezes na enumeração da planilha: no resumo da avaliação, junto da média ponderada, e na linha de cada questão. Desambiguado aqui como *Nota (resumo)* e *Nota (por questão)*. Pelo CPM o mesmo DER conta uma vez; mantido como o baseline contou, a confirmar com a equipe de métricas.

⚠️ A consulta traz o andamento dos demais avaliadores da inscrição — nome, datas e status —, que `AVL-AVA-06` (Consultar Outros Avaliadores) especifica como feature própria e que segue sem contagem. Separar esses DER num processo elementar daquela feature é decisão da equipe de métricas.

**Avaliar Inscrição** — EE · ALR 1 · DER 5 · Simples · 3 PF

```json
{"pe": "Avaliar Inscrição",
 "alr": ["Avaliação de Inscrição"],
 "der": ["Questão", "Nota questão", "Feedback geral", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Avaliação de Inscrição` — a transação grava a nota de cada questão e o parecer na avaliação da inscrição; a nota é subgrupo do mesmo arquivo lógico

**Total: 10 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); critérios em prosa na `## Origem`, porque a HU não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o DER *Nota* repetido na planilha desambiguado e o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/avaliacao-projetos/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Download de anexo pelo avaliador por link individual do documento, concedido apenas a quem tem direito à inscrição |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-028 |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
