<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-01
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
prioridade: P1
mvp: true
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Apurar Resultado da Etapa
> **Nível 3** - Feature Set: Apuração e Devolutiva — Domínio: Avaliação - `AVL-APU-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador apurar o resultado de uma etapa: a média ponderada de cada inscrição, a colocação dentro de cada bloco de estado e grupo de disputa e os cortes de classificação e de premiação que a etapa aplica.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/fechamento-etapa/:etapaId` (Fechamento de Etapa — ranking em blocos) ⚠️ *(rota derivada do data-model; o comportamento do ranking, dos cortes e dos indicadores vem da demanda SP05 — HU "Fechar Etapa de Avaliação")*

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

---

</div>

## Regras de negócio

1. A nota de cada inscrição na etapa é apurada em dois passos: primeiro a média **ponderada** das notas de cada avaliador, usando os pesos das questões; depois a média **aritmética** dessas médias entre os avaliadores com avaliação finalizada. O resultado é expresso com duas casas decimais, arredondado para cima no empate da terceira casa.
1a. A nota atribuída a cada questão vai de 1 a 5, e o peso de cada questão é sempre maior que zero.
2. A apuração considera apenas as inscrições cujas avaliações da etapa estão todas finalizadas. ⚠️ *(condição derivada do data-model — a confirmar na HU de fechamento)*
3. As inscrições competem entre si dentro do mesmo grupo de disputa — oferta (tipo de participante × modalidade × categoria × submodalidade) e enquadramento. *(a submodalidade foi acrescentada ao grupo em 2026-09-01, convergindo com a alocação)*
4. A abrangência da disputa deriva da **natureza da etapa**: em etapa **nacional**, todas as inscrições da etapa disputam entre si dentro de cada grupo, sem recorte por estado; em etapa **regional**, a disputa ocorre por estado dentro de cada grupo. → ver `AVL-ETA-02` (Cadastrar Etapa), regra da abrangência do corte. ⚠️ *(não há campo próprio que declare a natureza da etapa: hoje ela é lida da lista de perfis autorizados — a etapa é regional quando o Administrador Regional consta nela e nacional quando não consta. Declarar a natureza como campo da etapa é alteração de modelo ainda a decidir — ver `ANALISE_IMPACTO_SP05.md`, *Definições ainda em aberto*)*
5. As inscrições sem estado definido compõem um bloco próprio de disputa, identificado como Nacional.
6. Dentro de cada bloco de disputa, a colocação vai da maior para a menor média ponderada e recomeça em 1 a cada bloco.
7. É classificada a inscrição cuja colocação no bloco é menor ou igual à quantidade de classificados configurada na etapa; a classificação decorre exclusivamente da colocação, sem decisão individual de aprovação ou reprovação por inscrição.
8. Quando a etapa define quantidade de premiados, é premiada a inscrição cuja colocação no bloco é menor ou igual a essa quantidade; quando a etapa não define, nenhuma inscrição é premiada.
9. A condição de premiada é independente da condição de classificada: uma inscrição premiada pode não classificar e uma inscrição classificada pode não ser premiada.
10. Inscrições de mesma média ponderada no mesmo bloco ficam empatadas; o empate que atravessa uma linha de corte — de classificação ou de premiação — permanece pendente de desempate. → ver `AVL-APU-02` (Registrar Desempate).
11. A inscrição desclassificada na etapa sai da disputa do seu bloco: não recebe colocação e é apresentada ao fim do bloco. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)
12. A desclassificação e a sua reversão recalculam de imediato a colocação das demais inscrições do bloco e as duas linhas de corte, de classificação e de premiação. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Apurar o resultado da etapa por estado e grupo
  Given que a etapa é regional e as avaliações estão finalizadas
  When aciono a apuração da etapa
  Then o sistema calcula a média ponderada de cada inscrição e organiza a colocação em blocos de estado e grupo de disputa, recomeçando a colocação em 1 a cada bloco

Scenario: Apurar o resultado da etapa apenas por grupo
  Given que a etapa é nacional e as avaliações estão finalizadas
  When aciono a apuração da etapa
  Then o sistema organiza a colocação apenas por grupo de disputa, sem separar os blocos por estado

Scenario: Aplicar o corte de classificação automático
  Given que a etapa define 3 como quantidade de classificados e o bloco tem 8 inscrições apuradas
  When aciono a apuração da etapa
  Then o sistema marca como classificadas as três primeiras colocadas do bloco e como não classificadas as demais, sem pedir decisão por inscrição

Scenario: Aplicar o corte de premiação
  Given que a etapa define 2 como quantidade de premiados
  When aciono a apuração da etapa
  Then o sistema marca como premiadas as duas primeiras colocadas de cada bloco

Scenario: Etapa sem corte de premiação
  Given que a etapa está com a quantidade de premiados em branco
  When aciono a apuração da etapa
  Then o sistema apura o corte de classificação e não marca nenhuma inscrição como premiada

Scenario: Premiação independente da classificação
  Given que a etapa define 1 como quantidade de classificados e 3 como quantidade de premiados
  When aciono a apuração da etapa
  Then o sistema marca a segunda e a terceira colocadas como premiadas sem marcá-las como classificadas

Scenario: Acompanhar os indicadores da apuração
  Given que a etapa foi apurada
  When abro o resultado da etapa
  Then o sistema apresenta o total no ranking, os estados fechados sobre o total de estados, a quantidade que classifica, os empates na linha de corte, as vagas de premiação e os empates no corte de premiação

# ── Estados especiais ──────────────────────────────────────────

Scenario: Inscrições sem estado no bloco Nacional
  Given que há inscrições apuradas sem estado definido
  When aciono a apuração da etapa
  Then o sistema reúne essas inscrições no bloco Nacional e as classifica entre si

Scenario: Empate na linha de corte de classificação
  Given que duas inscrições do mesmo bloco têm a mesma média ponderada na colocação da linha de corte
  When apuro o resultado da etapa
  Then o sistema mantém as inscrições empatadas e sinaliza a necessidade de desempate de classificação

Scenario: Empate fora da linha de corte
  Given que duas inscrições do mesmo bloco empatam em colocação abaixo dos dois cortes da etapa
  When apuro o resultado da etapa
  Then o sistema mantém o empate sinalizado e não exige desempate para a etapa prosseguir

Scenario: Avaliações pendentes na etapa
  Given que há inscrições com avaliação ainda não finalizada
  When aciono a apuração da etapa
  Then o sistema apura apenas as inscrições com avaliações finalizadas e indica as pendentes

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão de apuração
  Given que meu perfil não tem permissão para apurar a etapa
  When tento apurar o resultado
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Premiação | seleção da tela de fechamento | seleção → Premiação | sim | premiação cujo resultado é apurado |
| Etapa | seleção da tela de fechamento | seleção → Etapa | sim | etapa da premiação selecionada |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Estado | Inscrição (sem estado = bloco Nacional) | agrupador (1º nível) |
| Grupo de disputa (tipo × modalidade × categoria × submodalidade) | Inscrição | agrupador (2º nível) |
| Enquadramento | Inscrição | agrupador (2º nível) |
| Colocação | derivado (média ponderada decrescente dentro do bloco) | padrão ↑ |
| Inscrição (Identificador · Protocolo) | Inscrição | — |
| Média ponderada | derivado (notas dos avaliadores finalizados, duas casas decimais) | ordenável |
| Avaliadores (finalizados / alocados) | derivado (contagem) | — |
| Classificação | derivado (corte de classificação da etapa) | — |
| Premiação | derivado (corte de premiação da etapa) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Média calculada | Média aritmética das médias ponderadas dos avaliadores finalizados, com duas casas decimais | Ao apurar a etapa |
| Colocação no bloco | Posição da inscrição no bloco de estado e grupo de disputa, recomeçando em 1 a cada bloco | Ao apurar a etapa |
| Status da apuração | Classificada quando a colocação alcança o corte de classificação; Não classificada nos demais casos | Ao apurar a etapa ⚠️ *(nomes do enum a confirmar no data-model)* |
| Premiada | Sim quando a colocação alcança o corte de premiação da etapa; Não quando a etapa não premia ou a colocação não alcança o corte | Ao apurar a etapa |

---

## Comportamento de tela

### Onde fica
Tela de fechamento em `/avaliacao-admin/fechamento-etapa/:etapaId`: após escolher premiação e etapa, o resultado aparece em blocos de estado e, dentro de cada estado, por grupo de disputa, com a colocação, a média ponderada e os selos de classificação e de premiação de cada inscrição; a linha de corte de classificação e, quando a etapa premia, a de premiação ficam destacadas no bloco. Uma faixa de indicadores acompanha o resultado com o total no ranking, os estados fechados sobre o total de estados, a quantidade que classifica, os empates na linha de corte, as vagas de premiação e os empates no corte de premiação. As inscrições sem estado aparecem no bloco Nacional, e a situação da etapa (Aberta ou Fechada) fica visível junto da seleção. ⚠️ *(layout derivado da demanda SP05 — protótipo não fornecido)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a apuração é processada |
| Erro de validação | Não se aplica (a apuração parte da premiação e da etapa selecionadas) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta os blocos com colocação, média ponderada, selos de classificação e de premiação e os indicadores da etapa |
| Empty state | Etapa sem inscrições avaliadas: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A apuração calcula a média ponderada de cada inscrição e ordena a colocação em blocos de estado e grupo de disputa, com a colocação recomeçando a cada bloco | cenário "Apurar o resultado da etapa por estado e grupo" |
| SC-02 | Etapa nacional é apurada entre todos os inscritos, apenas por grupo de disputa, sem separar blocos por estado | cenário "Apurar o resultado da etapa apenas por grupo" |
| SC-03 | O corte de classificação é aplicado automaticamente pela colocação, sem decisão por inscrição | cenário "Aplicar o corte de classificação automático" |
| SC-04 | Etapa com quantidade de premiados marca como premiadas as primeiras colocadas de cada bloco | cenário "Aplicar o corte de premiação" |
| SC-05 | Uma inscrição premiada que não alcança o corte de classificação permanece não classificada | cenário "Premiação independente da classificação" |
| SC-06 | Inscrições sem estado são apuradas no bloco Nacional | cenário "Inscrições sem estado no bloco Nacional" |
| SC-07 | Empate na colocação da linha de corte é sinalizado para desempate | cenário "Empate na linha de corte de classificação" |
| SC-08 | Os indicadores da etapa apresentam total no ranking, estados fechados, quantidade que classifica, empates no corte de classificação, vagas de premiação e empates no corte de premiação | cenário "Acompanhar os indicadores da apuração" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Apurar Resultado da Etapa | SE | 7 | 19 | Alta | 7 | 2026-10-04 |

### Memória de cálculo

**Apurar Resultado da Etapa** — SE. Formas de lógica: 2 (média ponderada e depois aritmética), 6 (grava a apuração da etapa), 7, 8, 9 (colocação, classificação e premiação derivadas do corte), 11, 12, 13. Intenção primária: apresentar o ranking apurado; a presença de cálculo e de dado derivado exclui CE.
- **ALR (7)**: Avaliação de Inscrição *(lê as notas dos avaliadores finalizados e grava a apuração — média, colocação, status e premiada)* · Inscrição *(identificador, protocolo, enquadramento)* · Premiação *(a Etapa e os cortes de classificação e de premiação)* · Categoria · Modalidade · Tipo de Participante *(o grupo de disputa: oferta × submodalidade)* · Usuário *(a UF que forma o bloco de estado)*.
- **DER (19)** — entrada (2): Premiação · Etapa. Saída (15): Estado · Grupo de disputa · Enquadramento · Colocação · Identificador · Protocolo · Média ponderada · Avaliações finalizadas · Avaliadores alocados · Classificação · Premiada · **Desclassificada** · **Justificativa da desclassificação** · Quantidade de classificados · Quantidade de premiados · Mensagem · Ação. Os dois últimos entraram em 2026-10-04 com a desclassificação manual, na mesma faixa de 6 a 19 DET — complexidade Alta e **7 PF** inalterados.
- **Fora da contagem**: as inscrições sem estado formam o bloco Nacional — é o mesmo DER Estado, sem valor; a ordenação (forma 13) não afeta tipo nem unicidade.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do efeito da desclassificação manual na apuração. *Antes* todas as inscrições com avaliação finalizada entravam na disputa do bloco e recebiam colocação; não havia como retirar uma do resultado. *Agora* a inscrição desclassificada sai da disputa, fica sem colocação e ao fim do bloco (RN11), e a desclassificação recalcula na hora as colocações e as duas linhas de corte (RN12). DER 17 → 19, sem mover o PF |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisões de produto (docqui) | Grupo corrigido e cenários ajustados | A **submodalidade** passa a compor o grupo de disputa, convergindo com a alocação. Os cenários e o SC-02, que ainda falavam em "etapa que autoriza o Administrador Regional", passam a falar em etapa regional e etapa nacional, seguindo o critério decidido para a abrangência do corte |
| 2026-09-01 | Decisões de produto (docqui) | Critério da abrangência trocado | A abrangência do corte passa a derivar da **natureza da etapa** — nacional apura entre todos os inscritos, regional apura por estado — e não mais da lista de perfis autorizados. A visibilidade da etapa por perfil passa a ser matriz do N2. ⚠️ Falta um campo que declare a natureza da etapa; hoje ela é lida dos perfis autorizados |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Regra corrigida | Cálculo da nota da inscrição passa a descrever os dois passos do `CalculoMediaEtapaService` (ponderada por avaliador → aritmética entre avaliadores) e a faixa de nota 1–5; rota da tela corrigida |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Corte de classificação automático e corte de premiação independente; ranking em blocos de estado e grupo com colocação por bloco; indicadores da etapa |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do data-model (Apuração por Etapa) — HU de fechamento não fornecida ⚠️ |

---

*Feature Set: Apuração e Devolutiva · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
