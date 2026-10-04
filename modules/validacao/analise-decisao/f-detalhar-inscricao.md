<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-01
feature_set: VAL-ANA
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-018_Analisar_Validar_Inscricao
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

# Detalhar Inscrição
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-01`

## Descrição
Permite ao validador detalhar uma inscrição em modo leitura, reunindo os dados do formulário, o questionário, os documentos, a equipe, os termos e o histórico de validação para embasar a decisão.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — |
| [`PDTIC25093-68`](../../../analise-impacto/AIM-PDTIC25093-68.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/inscricoes/:inscricaoId/detalhe` (Detalhe da Inscrição)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. O detalhe da inscrição é somente leitura: a análise não altera os dados informados pelo participante.
2. As ações de decisão dependem da situação: iniciar a validação exige a situação Finalizada; aprovar, rejeitar e solicitar ajuste exigem a situação Em Validação.
3. Uma inscrição já Validada ou Rejeitada tem o parecer e a data da decisão associados ao seu veredito.
4. O histórico de validação registra cada transição de situação com data, responsável e parecer.
5. O detalhe de uma inscrição só é acessível ao validador vinculado à unidade federativa da inscrição.
6. Cada documento anexado à inscrição tem um identificador público próprio, distinto do identificador interno do documento e da inscrição, que endereça individualmente o download daquele documento.
7. O identificador público é único no sistema e acompanha o documento enquanto ele estiver anexado à inscrição; documentos diferentes nunca compartilham o mesmo identificador.
8. O download de um documento pelo seu identificador público alcança apenas quem tem direito à inscrição — o administrador com alcance sobre a unidade federativa da inscrição, o avaliador alocado a ela e o participante autor —, e esse direito é conferido a cada acesso, independentemente de quem detenha o endereço do documento.

> O mesmo endereçamento individual por documento habilita o download de anexo pelo avaliador alocado, especificado em `AVL-AVA-03` Avaliar Inscrição.

---

## Cenários

```gherkin
Feature: Detalhar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Abrir o detalhe completo da inscrição
    Given que selecionei uma inscrição na Fila de Validação
    When abro o detalhe da inscrição
    Then o sistema exibe os dados do formulário, o questionário, os documentos, a equipe, os termos e o histórico de validação

  Scenario: Fazer o download de um documento anexado
    Given que estou no detalhe de uma inscrição a que tenho direito e que possui documentos
    When aciono o download de um documento
    Then o sistema confere o meu direito à inscrição e disponibiliza o arquivo pelo endereço individual daquele documento

  Scenario: Endereço individual por documento anexado
    Given que a inscrição possui mais de um documento anexado
    When consulto a relação de documentos
    Then cada documento é endereçado por um link de download próprio

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Ações disponíveis para inscrição finalizada
    Given que a inscrição está na situação Finalizada
    When abro o detalhe da inscrição
    Then o início da validação fica disponível e as ações de aprovar e rejeitar não

  Scenario: Veredito de inscrição já decidida
    Given que a inscrição está na situação Validada
    When abro o detalhe da inscrição
    Then o sistema apresenta o parecer e a data da decisão

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Inscrição de outra unidade federativa
    Given que a inscrição pertence a uma unidade a que não estou vinculado
    When tento abrir o detalhe da inscrição
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."

  Scenario: Download de documento por quem não tem direito à inscrição
    Given que tenho o link de download de um documento de uma inscrição a que não tenho direito
    When aciono esse link
    Then o sistema bloqueia o download e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Protocolo | Inscrição | somente leitura | texto | — | — |
| Identificação do participante | Inscrição | somente leitura | texto | — | — |
| Situação | Inscrição | somente leitura | lista (situações de validação) | — | — |
| Dados do formulário | Inscrição (respostas do formulário) | somente leitura | grupo de respostas do formulário dinâmico | — | — |
| Questionário | Inscrição (respostas de questão) | somente leitura | grupo de respostas do questionário | — | — |
| Documentos | Inscrição (documentos) | somente leitura | lista de anexos, cada um com endereço individual de download | — | download restrito a quem tem direito à inscrição |
| Equipe | Inscrição (membros de equipe) | somente leitura | cards com nome, CPF (→ ver FIELD-DICTIONARY: CPF), e-mail (→ ver FIELD-DICTIONARY: E-mail) e telefone (→ ver FIELD-DICTIONARY: Telefone) | — | — |
| Termos | Inscrição (aceites de termo) | somente leitura | lista de termos aceitos | — | — |
| Histórico de validação | Inscrição (histórico) | somente leitura | linha do tempo de transições de situação | — | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Identificador público do documento | Identificador próprio do documento, único no sistema | Quando o documento é anexado à inscrição |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/inscricoes/:inscricaoId/detalhe` (Detalhe da Inscrição), aberta em nova aba a partir da Fila de Validação: cabeçalho com identificação e protocolo, indicadores de progresso (preenchimento do formulário, contagem de documentos, contagem de membros da equipe e progresso dos termos), seções retráteis (dados do formulário, questionário, documentos com pré-visualização e download por endereço individual de cada documento, equipe em cards e termos), histórico em linha do tempo e as ações de decisão conforme a situação. O endereço de um documento não dispensa a conferência do direito à inscrição a cada acesso, e é o mesmo mecanismo que atende o download de anexo pelo avaliador alocado, fora desta tela (`AVL-AVA-03`). O bloco de Conferência de Ajustes e o acesso à Auditoria de Ajustes são atendidos pelas features do Feature Set Ajustes da Inscrição (VAL-AJU).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (tela de leitura) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe o detalhe completo da inscrição, com cada documento acessível pelo seu endereço individual, e as ações permitidas pela situação |
| Empty state | Seção sem conteúdo (ex.: sem documentos ou sem equipe): "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe exibe formulário, questionário, documentos, equipe, termos e histórico de validação | cenário "Abrir o detalhe completo da inscrição" |
| SC-02 | As ações de decisão disponíveis correspondem à situação da inscrição | cenário "Ações disponíveis para inscrição finalizada" |
| SC-03 | Uma inscrição já decidida apresenta o parecer e a data do veredito | cenário "Veredito de inscrição já decidida" |
| SC-04 | Cada documento anexado é baixado por um endereço individual próprio, sem expor os demais documentos da inscrição | cenário "Endereço individual por documento anexado" |
| SC-05 | O download por esse endereço é negado a quem não tem direito à inscrição | cenário "Download de documento por quem não tem direito à inscrição" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Detalhar Inscrição | SE | 5 | 37 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

- **Detalhar Inscrição** — ALR (5): Inscrição · Premiação · Categoria · Modalidade · Tipo de Participante. DER (37): Inscrição · Status · E-mail · Prêmio · Categoria · Modalidade · Tipo de Participante · Percentual Campos Preenchidos · Qtd Premios Preenchidos · Qtd arquivos anexados · Qtd membros cadastrados · Qtd termos aceitos · CPF · Data · UF · Anexo · Termos · E-mail · Número · Qtd Questoes do formulário · Título questão · Obrigatoriedade questão · Resposta questão · Nome arquivo · Tipo arquivo · Data anexo · Tamanho · Equipe · E-mail equipe · Telefone · CPF membro equipe · Número Termo · Data/Hora aceite · Histórico de Status · Data/hora mudança de status · Comentário · Ação.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Download de documento por endereço individual e seguro, conferido a cada acesso a quem tem direito à inscrição — mesmo mecanismo que habilita o download de anexo pelo avaliador (`AVL-AVA-03`) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
