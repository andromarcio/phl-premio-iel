<!-- docqui: 2.8.0 | prompt: PROMPT_1A | atualizado: 2026-08-25 -->
# Domínio: Avaliação
> **Nível 1** - Visão estratégica do domínio - `AVL`

## Descrição
Responde por toda a avaliação dos projetos — da configuração das etapas e da alocação de avaliadores ao registro de notas e pareceres, à apuração e à devolutiva. Mantém as alocações, as notas por questão, os pareceres, a apuração por etapa (média, classificação, desempate e fechamento por UF) e a devolutiva consolidada ao participante. É consumido pela Inscrição, cujo status de aprovação por etapa e cuja devolutiva refletem o resultado da avaliação.

### O que este domínio NÃO faz
| Descrição | Pertence a |
|---|---|
| Conferir e aprovar a inscrição antes da avaliação | Validação |
| Definir o questionário e os critérios avaliados | Configuração da Premiação |
| Preencher a inscrição avaliada | Inscrição |
| Autenticar o avaliador (login) | Acesso e Gestão / SSO |

---

## Feature Sets

| Feature Set | Descrição | Features |
|---|---|---|
| [**Etapas e Configuração da Avaliação**](./etapas-configuracao/README.md) <small>AVL-ETA</small> | Definir etapas, modo de avaliação, critérios de desempate e termo de confidencialidade da edição | 7 |
| [**Alocação de Avaliadores**](./alocacao/README.md) <small>AVL-ALO</small> | Cadastrar avaliadores e alocá-los a grupos e a inscrições por etapa | 4 |
| [**Avaliação de Projetos**](./avaliacao-projetos/README.md) <small>AVL-AVA</small> | Registrar notas por questão e parecer, com aceite do termo de confidencialidade e avaliação às cegas quando configurada | 5 |
| [**Painel Administrativo de Avaliações**](./painel-administrativo/README.md) <small>AVL-PAI</small> | Acompanhar e consolidar as avaliações de cada etapa e inscrição | 3 |
| [**Apuração e Devolutiva**](./apuracao-devolutiva/README.md) <small>AVL-APU</small> | Apurar médias, classificar, aplicar desempate, fechar etapa por UF e consolidar a devolutiva (apoio de IA + revisão humana) | 7 |

---

## Regras transversais de negócio

1. Um avaliador só acessa os projetos que lhe foram alocados.
2. A avaliação é sigilosa: exige aceite de termo de confidencialidade e é feita às cegas quando a edição assim configura.
3. A nota final de um projeto resulta das notas por questão conforme os pesos e o fator de pontuação configurados.
4. Empates são resolvidos pelos critérios de desempate configurados; cada decisão de desempate é registrada com justificativa e responsável.
5. A devolutiva consolidada (com apoio de IA) só é liberada ao participante após revisão humana.
6. O fechamento de uma etapa por UF é registrado e define quem avança para a etapa seguinte.
7. Toda mudança de status de uma avaliação é registrada em histórico.

---

## Integrações com outros domínios

### Leitura — domínios que consomem dados deste domínio
| Domínio | O que consome | Como |
|---|---|---|
| Inscrição | Status de aprovação por etapa e devolutiva liberada, exibidos ao participante | a confirmar no PROMPT_1B |

### Escrita — domínios que criam ou alteram dados deste domínio
| Domínio | O que altera | Situação |
|---|---|---|
| Inscrição | Fornece as inscrições validadas a avaliar | Após a aprovação na validação |
| Configuração da Premiação | Fornece questionário, critérios de avaliação e etapas | Ao montar/alterar a edição |
| Acesso e Gestão | Define o escopo regional do administrador na condução da avaliação | Ao cadastrar administradores regionais |

---

<div class="dev-only">

## Entidades do domínio

> Campos completos no data-model — ver `global/data-models/avaliacao.md`.

| Entidade | Descrição | Campos no DATA-MODEL.md |
|---|---|---|
| Avaliação de Inscrição | Alocação e avaliação de um projeto por um avaliador | → ver DATA-MODEL.md: Avaliação de Inscrição |
| Alocação de Avaliadores | Alocação de avaliadores por grupo | → ver DATA-MODEL.md: Alocação de Avaliadores |

> **ALIs deste domínio** (2): Avaliação de Inscrição (10 PF) · Alocação Avaliadores (7 PF), 17 PF no total. Ver `global/data-models/avaliacao.md`.

</div>

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-08-25 | Engenharia reversa (docqui) | N1 negocial criado | Domínio derivado do N0, das HUs e do data-model |

---

*Última revisão: 2026-08-25*

*Links: Etapas e Configuração da Avaliação `AVL-ETA` · Alocação de Avaliadores `AVL-ALO` · Avaliação de Projetos `AVL-AVA` · Painel Administrativo de Avaliações `AVL-PAI` · Apuração e Devolutiva `AVL-APU` · [INDEX geral](../INDEX.md)*
