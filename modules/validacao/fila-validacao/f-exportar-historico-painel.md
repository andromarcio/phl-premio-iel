<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-FIL-03
feature_set: VAL-FIL
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [VAL-FIL-02]
origem:
  tipo: issue
  chave: HU-023_Dashboard_Gerencial_Validacao
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

# Exportar Histórico do Painel de Validação
> **Nível 3** - Feature Set: Fila e Painel de Validação — Major Feature Set: Validação - `VAL-FIL-03`

## Descrição
Permite ao administrador levar para fora do sistema o histórico das inscrições que sustentam as métricas do painel de validação, em uma planilha com uma linha por inscrição acrescida do nome e do telefone de contato do participante.

A exportação parte do próprio painel gerencial, pela ação "Exportar Excel": o recorte já aplicado nos filtros do painel é o mesmo da planilha, e o arquivo é disponibilizado para download.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-023_Dashboard_Gerencial_Validacao`](../../../hus/HU-023_Dashboard_Gerencial_Validacao.docx) | Criação | — |
| [`PDTIC25093-58`](../../../analise-impacto/AIM-PDTIC25093-58.md) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Dashboard Gerencial de Validação (`/validacao-inscricao/dashboard`), botão "Exportar Excel"

**Fidelidade ao protótipo**: referência — `prototypes/validacao/fila-validacao/flow.html`

---

</div>

## Regras de negócio

1. O conjunto exportado é exatamente o conjunto de inscrições do recorte vigente — premiação, unidade federativa, categoria, modalidade e período —, sem acrescentar nem omitir inscrição alguma em relação ao que as métricas consolidam. → ver `VAL-FIL-02` (Acompanhar Painel de Validação).
2. A planilha traz uma linha por inscrição, com os dados de acompanhamento da inscrição acrescidos do nome do participante e do telefone de contato.
3. O nome do participante e o telefone não são dados próprios da inscrição: o sistema os resolve a partir dos rótulos dos campos preenchidos pela inscrição e a informação sai vazia quando nenhum rótulo corresponde. *(resolução best-effort, comportamento herdado do sistema em produção. **Limitação conhecida e aceita pelo produto em 2026-09-01**: renomear o rótulo na configuração do tipo de participante esvazia a coluna na planilha, sem erro e sem aviso)*
4. A exportação alcança todas as unidades federativas da premiação, sem recorte por escopo regional de acesso. *(decorrência da restrição da exportação ao Administrador Nacional — recurso APIPIT.22, confirmado em 2026-09-01; a matriz de permissões do N2 é a fonte única)*

---

## Cenários

```gherkin
Feature: Exportar Histórico do Painel de Validação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar o histórico das inscrições do painel
    Given que acompanho as métricas de uma premiação
    When aciono "Exportar Excel"
    Then o sistema gera a planilha com uma linha por inscrição do mesmo recorte e a disponibiliza para download

  Scenario: Nome do participante e telefone no histórico exportado
    Given que exportei o histórico de uma premiação
    When abro o arquivo gerado
    Then cada linha traz o nome do participante e o telefone resolvidos a partir dos rótulos dos campos preenchidos pela inscrição

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Rótulo de contato renomeado na configuração do tipo de participante
    Given que o rótulo do campo que informa o telefone foi renomeado e nenhum rótulo corresponde mais
    When exporto o histórico
    Then o sistema gera a planilha com o telefone vazio nas inscrições afetadas

  Scenario: Exportação sem premiação selecionada
    Given que nenhuma premiação está selecionada no painel
    When observo a exportação
    Then o sistema mantém a exportação indisponível até que uma premiação seja selecionada

  Scenario: Recorte sem inscrições
    Given que os filtros do painel não devolvem nenhuma inscrição
    When exporto o histórico
    Then a planilha é entregue sem linhas de inscrição

  Scenario: Exportação sem recorte regional
    Given que acompanho as métricas de uma premiação
    When exporto o histórico
    Then a planilha traz as inscrições de todas as unidades federativas da premiação

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Perfil sem acesso à exportação do histórico
    Given que meu perfil não tem permissão para exportar o histórico
    When acompanho as métricas da premiação
    Then o sistema não oferece a ação "Exportar Excel"
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Critérios do painel | Inscrição | seleção → Inscrição | somente leitura | conjunto de critérios | sim | herdados do painel que originou a exportação — premiação, unidade federativa, categoria, modalidade e período —, com a premiação obrigatória |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Conteúdo do arquivo | Uma linha por inscrição do recorte apurado no painel | Ao exportar o histórico |
| Nome do Participante | Rótulo correspondente entre os campos preenchidos pela inscrição; vazio quando não há correspondência | Ao exportar o histórico |
| Telefone | Rótulo correspondente entre os campos preenchidos pela inscrição; vazio quando não há correspondência | Ao exportar o histórico |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê | Cada linha da planilha é uma inscrição do recorte apurado no painel — regras 1 e 2 |
| Resposta de Formulário | lê | Origem do nome do participante e do telefone, resolvidos pelos rótulos dos campos preenchidos — regra 3 |
| Premiação | lê | Delimita o recorte exportado e é pré-requisito da exportação — regra 1 |
| Unidade Federativa | lê | Compõe o recorte exportado — regra 1 |
| Categoria | lê | Compõe o recorte exportado — regra 1 |
| Modalidade | lê | Compõe o recorte exportado — regra 1 |

---

## Comportamento de tela

### Onde fica
Ação "Exportar Excel" no Dashboard Gerencial de Validação (`/validacao-inscricao/dashboard`), ao lado dos filtros que definem o recorte. A planilha é baixada pelo navegador com os mesmos critérios aplicados no painel, e a ação é oferecida apenas aos perfis com acesso aos relatórios administrativos.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto a planilha é gerada |
| Erro de validação | Ação permanece desabilitada enquanto não houver premiação selecionada |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | O download da planilha começa |
| Empty state | Recorte sem inscrições gera planilha sem linhas de inscrição |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A planilha traz uma linha por inscrição do mesmo recorte apurado no painel | cenário "Exportar o histórico das inscrições do painel" |
| SC-02 | Cada linha traz o nome do participante e o telefone quando há rótulo correspondente na inscrição | cenário "Nome do participante e telefone no histórico exportado" |
| SC-03 | A exportação é oferecida apenas aos perfis com acesso aos relatórios administrativos | cenário "Perfil sem acesso à exportação do histórico" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Exportar Histórico do Painel de Validação | SE | 6 | 18 | Alta | 7 | 2026-09-01 |

### Memória de cálculo

**Exportar Histórico do Painel de Validação** — SE. Formas de lógica: 4 (o recorte do painel), 7, 8, 9 (o nome e o telefone do participante são **criados** a partir dos rótulos dos campos preenchidos — não existem como atributo da Inscrição), 11, 12. É a derivação que exclui CE.
- **ALR (6)**: Inscrição *(uma linha por inscrição, e as Respostas de Formulário de onde saem nome e telefone)* · Validação Inscrição *(a situação de validação de cada inscrição)* · Premiação · Categoria · Modalidade · Usuário *(a UF do recorte)*.
- **DER (18)** — entrada (6): Premiação · Unidade federativa · Categoria · Modalidade · Data início · Data fim. Saída (10): Protocolo · Premiação · Categoria · Modalidade · Tipo de participante · UF · Situação · Data · Nome do Participante · Telefone · Mensagem · Ação.
- **Fora da contagem**: a coluna que sai vazia por rótulo renomeado (regra 3) é o mesmo DER, sem valor.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada em `prototypes/validacao/fila-validacao/flow.html`, no fluxo que já cobre a tela onde ela acontece — fidelidade **referência** |
| 2026-09-01 | Especificação (docqui) | Feature criada | N3 negocial da exportação do histórico do painel de validação, separada de `VAL-FIL-02` **Acompanhar Painel de Validação** pela decisão de produto de 2026-09-01: os dados diferem, e não só de formato — a tela mostra agregados e a planilha traz uma linha por inscrição, com nome e telefone, que a tela não tem. As regras, os cenários e os campos automáticos da exportação vieram daquela feature, que passa a referenciar esta |

---

*Feature Set: Fila e Painel de Validação · Major Feature Set: Validação · Última revisão: 2026-09-01*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
