<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-06
feature_set: AVL-APU
dominio: AVL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-037_Relatorio_Inscricoes_Em_Andamento
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

# Gerar Relatório de Inscrições Paradas
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-06`

## Descrição
Permite ao administrador gerar o relatório das inscrições paradas de uma premiação — as que estão Em Andamento ou Rascunho — segmentado por UF, status e tipo de participante, com o preenchimento de cada inscrição, disponível na tela e em planilha para uso fora do sistema.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-037_Relatorio_Inscricoes_Em_Andamento`](../../../hus/HU-037_Relatorio_Inscricoes_Em_Andamento.docx) | Criação | — |
| [`PDTIC25093-56`](../../../analise-impacto/AIM-PDTIC25093-56.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: a tela Relatório de Inscrições Paradas (rota `/validacao-inscricao/relatorio-inscricoes-paradas`); o relatório é gerado ao selecionar a premiação e a mesma tela oferece a ação "Exportar XLSX"

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-relatorios.html`

---

</div>

## Regras de negócio

1. O relatório considera apenas as inscrições ativas com status Em Andamento ou Rascunho.
2. O relatório é segmentado por UF, status e tipo de participante, e cada tipo de participante tem seu próprio conjunto de campos preenchidos.
3. Cada grupo reúne as colunas fixas de identificação seguidas dos campos preenchidos pelas inscrições daquele tipo de participante.
4. Os dias parados de uma inscrição são contados a partir da última atualização e, na ausência dela, a partir da data de início.
5. O relatório abrange todas as UFs da premiação, sem recorte por escopo regional de acesso. *(decorrência da restrição do relatório ao Administrador Nacional — recurso APIPIT.22, confirmado em 2026-09-01; a matriz de permissões do N2 é a fonte única)*
6. A planilha reproduz exatamente os dados apurados no relatório em tela — a mesma segmentação, os mesmos valores e o mesmo escopo.
7. A planilha traz um resumo com a contagem por grupo e o total, além do detalhamento de cada grupo por UF, status e tipo de participante.
8. O nome de cada seção de grupo na planilha é único e limitado a 31 caracteres.

---

## Cenários

```gherkin
Feature: Gerar Relatório de Inscrições Paradas

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Gerar o relatório ao selecionar a premiação
    Given que escolho uma premiação com inscrições paradas
    When o relatório é gerado
    Then o sistema apresenta o total de inscrições paradas e os grupos por UF, status e tipo de participante

  Scenario: Estreitar por UF
    Given que gerei o relatório de uma premiação
    When seleciono uma UF
    Then o sistema apresenta apenas as inscrições paradas daquela UF

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Premiação não selecionada
    Given que estou na tela do relatório
    When não seleciono nenhuma premiação
    Then o sistema não gera o relatório e mantém a seleção da premiação pendente

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Premiação sem inscrições paradas
    Given que a premiação não tem inscrições Em Andamento nem Rascunho
    When o relatório é gerado
    Then o sistema exibe "Nenhum registro encontrado."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Exportar o relatório em planilha
    Given que gerei o relatório de inscrições paradas de uma premiação
    When aciono a exportação em XLSX
    Then o sistema gera a planilha com o resumo por grupo, o total e o detalhamento de cada grupo e a disponibiliza para download

  Scenario: Exportação sem premiação selecionada
    Given que ainda não selecionei uma premiação
    When observo a exportação
    Then o sistema mantém a exportação indisponível até que uma premiação seja selecionada

  Scenario: Exportação respeita o escopo do relatório
    Given que gerei o relatório restrito a uma UF
    When exporto o relatório
    Then o sistema gera a planilha apenas com as inscrições daquela UF

  Scenario: Exportação sem recorte regional
    Given que gerei o relatório sem selecionar nenhuma UF
    When exporto o relatório
    Then o sistema gera a planilha com as inscrições paradas de todas as UFs da premiação

  Scenario: Usuário sem permissão de acesso ao relatório
    Given que meu perfil não tem permissão para acessar o relatório
    When tento gerar o relatório
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Premiação | entrada do usuário | seleção → Premiação | sim | seleção com filtro por nome; gera o relatório ao escolher |
| UF | entrada do usuário | seleção → UF | não | filtro opcional; lista todas as UFs da premiação |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | — |
| Identificação | Inscrição | — |
| E-mail | Inscrição | — |
| Categoria | Inscrição | — |
| Modalidade | Inscrição | — |
| Tipo de Participante | Inscrição | agrupador |
| Enquadramento | Inscrição | — |
| UF | Inscrição | agrupador |
| Status | Inscrição | agrupador |
| % Preenchimento | derivado (campos preenchidos) | — |
| Dias Parado | derivado (última atividade) | padrão ↓ |
| Data de Início | Inscrição | — |
| Última Atualização | Inscrição | — |
| Campos preenchidos da inscrição | Inscrição (por tipo de participante) | colunas dinâmicas por grupo |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Total de inscrições paradas | Contagem das inscrições Em Andamento e Rascunho | Ao gerar o relatório |
| Dias Parado | Diferença entre hoje e a última atividade da inscrição | Ao gerar o relatório |
| Nome do arquivo | inscricoes-paradas.xlsx | Ao exportar o relatório |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/relatorio-inscricoes-paradas`: seleção obrigatória da premiação e opcional da UF, o total de inscrições paradas e um agrupamento por UF · status · tipo de participante, cada grupo com as colunas fixas e as colunas dinâmicas dos campos preenchidos. A tela é alcançada pela ação "Inscrições Paradas" da Fila de Validação, oferecida apenas aos perfis com acesso aos relatórios administrativos, e o filtro de UF lista todas as UFs da premiação, sem recorte regional. ⚠️ *(restrição ao Administrador Nacional — recurso APIPIT.22 — é decisão de produto pendente; a matriz vive no N2)* A ordem apresenta Em Andamento antes de Rascunho, UF em ordem alfabética com "(Sem UF)" ao final e, dentro do grupo, as inscrições mais paradas primeiro. A ação "Exportar XLSX" na mesma tela entrega o relatório em planilha — uma aba "Resumo" com a contagem por grupo e o total, e uma aba por grupo — e fica desabilitada enquanto não há premiação selecionada ou durante o carregamento.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o relatório é gerado |
| Erro de validação | Mantém a seleção da premiação pendente enquanto não houver premiação escolhida |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta o total e os grupos com as colunas fixas e dinâmicas; a exportação disponibiliza o arquivo inscricoes-paradas.xlsx para download |
| Empty state | Premiação sem inscrições paradas: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao selecionar a premiação, o relatório apresenta o total e os grupos por UF × status × tipo de participante | cenário "Gerar o relatório ao selecionar a premiação" |
| SC-02 | Apenas inscrições Em Andamento ou Rascunho entram no relatório | regra de negócio 1 |
| SC-03 | Os dias parados vêm da última atualização, ou da data de início quando não houve atualização | regra de negócio 4 |
| SC-04 | O relatório alcança todas as UFs da premiação, sem recorte por escopo regional de acesso | regra de negócio 5 |
| SC-05 | A planilha traz a aba de resumo com a contagem por grupo e o total, e uma aba por grupo com colunas fixas e dinâmicas | cenário "Exportar o relatório em planilha" |
| SC-06 | Os dados exportados coincidem com os do relatório em tela e respeitam o mesmo escopo | cenário "Exportação respeita o escopo do relatório" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Relatório de Inscrições Paradas | SE | 5 | 37 | Complexo | 7 | 2026-02-28 |
| Exportar Relatório de Inscrições Paradas para Excel | SE | 5 | 37 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

- **Relatório de Inscrições Paradas** — ALR (5): Premiação · Modalidade · Categoria · Tipo de Participante · Inscrição. DER (37): Protocolo · Identificação · E-mail · Categoria · Modalidade · Tipo Participante · Enquadramento · UF · Status · % Preenchimento · Dias Parado · Data Início · Última Atualização · CNPJ · Razão social · Nome fantasia · Estado · Cidade · CEP · Endereço · Site · Redes sociais · Setor · CPF · Nome completo · E-mail · Gênero · Estado · Cidade · CEP · Endereço · Data de nascimento · Telefone · Telefone · Área · Cargo · Ação.

**Total: 14 PF** (2 processos elementares).

> A feature absorve **dois processos elementares** com ALR e DER idênticos. Do ponto de vista da feature é uma ação só — gerar o relatório, disponível em tela e em planilha —, mas nestes sistemas a exportação é contada como PE distinto por convenção de contrato (ver `global/SIZING.md` → *Funcionalidades iguais em formatos de saída diferentes*). Unificar as features não retirou PF.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/apuracao-devolutiva/flow-relatorios.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisão 6 (docqui) | Features unificadas | `AVL-APU-07` Exportar Relatório de Inscrições Paradas incorporada: os dois processos elementares têm ALR e DER idênticos, logo é uma ação só do ponto de vista da feature. A contagem não muda — a feature passa a absorver dois PE, 14 PF. O ID `AVL-APU-07` fica aposentado e não será reutilizado |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Relatório restrito ao Administrador Nacional (APIPIT.22): abrangência passa a todas as UFs, sem recorte regional; removido o cenário de administrador sem UF vinculada |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-037 |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
