<!-- docqui: 2.16.0 | prompt: — | atualizado: 2026-09-02 -->
# Replicar: o caminho de menu no `## Telas` do N2

> **O que é este arquivo.** Ordem de serviço para levar a outros repositórios de documentação a coluna **Caminho de menu** — por onde o usuário chega à tela pelo menu do sistema. Transitório: propagado e conferido, apague-o.

---

## 1. A decisão, e por que não foi na Superfície nem na Descrição

O caminho de menu é propriedade **da tela**, não da feature. Medido nesta instância: **71 telas** nos N2 atendem **126 vínculos de feature** — **35 delas (49%) servem mais de uma**. Registrar o caminho no N3 duplicaria o mesmo dado em metade dos casos, e dado duplicado envelhece em ritmos diferentes.

Foi por isso que ele **não** entrou em nenhum dos dois lugares que pareciam naturais:

| Onde não entrou | Por quê |
|---|---|
| `## Superfície` do N3 | não é prosa: é marcador escaneado pelo `validate-doc.mjs`, que lê o primeiro marcador para decidir qual seção de detalhamento exigir. A linha tem gramática fixa — `**[tipo]** — [rota \| origem \| comando \| gatilho]`. Texto livre ali quebra o parser ou obriga a afrouxá-lo |
| 2º parágrafo da `## Descrição` | é a camada do "como se usa", em prosa de negócio, e a única que o FD-8 deliberadamente não mede. Transformá-la em campo estruturado embaralha as duas coisas |

O N2 já é a **fonte única** desse tipo de fato consolidado — foi a mesma decisão tomada para as **permissões**, e o template do N3 diz explicitamente que features não tratam de perfis.

---

## 2. A convenção

Na tabela `## Telas` do N2, uma coluna **Caminho de menu** logo após **Tela**:

```
| Tela | Caminho de menu | Rota (implementada) | Features atendidas | Descrição |
|---|---|---|---|---|
| Alocação por Inscrição | Avaliação › Alocação por Inscrição | `/avaliacao-admin/alocacao-participante` | … | … |
| Cadastrar Avaliador | — | `/avaliacao-admin/alocacao-matriz` (diálogo) | … | … |
```

- Separador de nível: **`›`** (U+203A), com espaço dos dois lados. Sem o item raiz ("Início"/"Home") — ele não é escolha do usuário.
- **`—`** quer dizer *a tela não tem entrada própria no menu*: chega-se a ela a partir de outra. Diálogos, editores, drawers e telas de detalhe caem quase todos aqui, e o traço é **informação**, não lacuna.
- **`⚠️ a conferir`** quando o caminho ainda não foi levantado. Não invente: caminho de menu errado é pior que ausente, porque parece conferido.
- Feature sem tela (CLI, Job, API) não aparece em `## Telas` — é assim que o "quando aplicável" se resolve sozinho.

**Exceção que fica no N3**: ponto de entrada da *feature*, não da tela — link público, link de e-mail, deep link. Esse vai no `### Onde fica`, dentro de `## Comportamento de tela`.

---

## 3. O que fazer no repositório de destino

> ⚠️ **Ordem obrigatória**: o **engine sobe primeiro**, as instâncias depois. Sincronizar uma instância a partir de um engine cujo conserto ainda não está na `main` dele reverte o conserto em silêncio (CLAUDE.md → *Ordem do push*).

### 3.1 `engine/templates/modules/_template-dominio/_template-feature-set/README.md`

Na seção `## Telas`, acrescentar a coluna e a legenda:

```
| Tela | Caminho de menu | Rota sugerida | Features atendidas | Descrição |
|---|---|---|---|---|
| [Nome da tela] | [Menu › Submenu › Item] | `/[rota]` | **[Nome da Feature]** <small>[SIGLA]-[SFS]-01</small> | [o que a tela mostra] |
```

E, no comentário da seção, a regra: separador `›`, sem o item raiz; `—` para tela sem entrada de menu; `⚠️ a conferir` para o que não foi levantado.

### 3.2 `engine/prompts/PROMPT_2A_N2_negocio.md`

No passo que monta a tabela `## Telas`, acrescentar a instrução de preencher o caminho de menu e, principalmente, a de **não inventar**: sem fonte, sai `⚠️ a conferir`.

### 3.3 `scripts/gera-docx.py` — capítulo **Telas** na Especificação Funcional

Sem isso a coluna não chega a quem recebe o documento. O capítulo entra depois de *Funcionalidades* e antes de *Jornada do Usuário*, com três colunas — Tela, Caminho de menu, Descrição — mais a legenda do `—`. Copiar o bloco `# 3. Telas` de `build_body` deste repositório. Ele **degrada bem**: N2 ainda sem a coluna cai numa tabela com o que houver, em vez de sumir com o capítulo.

### 3.4 N2 já escritos

A coluna pode ser inserida em lote (é estrutura), mas **o conteúdo não**: o caminho sai do sistema, não de um script. Ao inserir em lote, lembre que a **linha separadora** precisa ganhar uma célula também — foi o erro que aconteceu aqui: 21 tabelas ficaram com cabeçalho de 5 colunas e separador de 4, e o Markdown não reclama.

---

## 4. Como conferir que pegou

1. `awk -F'|' '/^\| /{print NF}' modules/<dom>/<fs>/README.md | sort | uniq -c` na faixa da tabela `## Telas` — tem de sair **um único valor**. Cabeçalho e separador com larguras diferentes é o erro do item 3.4.
2. Gere um `.docx` e confirme que o capítulo **Telas** aparece com a coluna preenchida — não basta a coluna existir no Markdown.
3. Apague a coluna de um N2 e gere de novo: o capítulo tem de continuar saindo (fallback do 3.3). Se sumir, o capítulo está condicionado à coluna e some justamente nos N2 ainda não atualizados. Desfaça.

---

## 5. Um cuidado sobre a fonte

Nesta instância o `global/MASTER.md` registra que *"o menu lateral é montado a partir do que o portal corporativo devolve, não é fixo no código"*, e o `CONFORMIDADE-CODIGO.md` que *"o menu é montado com o que o portal devolve — não há rota escondida por código"*.

Ou seja: **o caminho é dado do portal**. Renomear um item lá muda o caminho sem tocar no sistema, e a coluna envelhece em silêncio. Carimbe a data da conferência, como já se faz com as outras seções conciliadas com o código, e diga de onde veio. Os caminhos preenchidos aqui em 2026-09-02 saíram dos **breadcrumbs dos protótipos** (conciliados com o sistema em 2026-08-28), não do `configuracoes.json` do portal — é uma fonte de segunda mão e está anotado como tal.

---

## 6. Origem

Decisão tomada no `premio-iel` em 2026-09-02, a partir da pergunta "caminho de menu vai na Superfície ou na Descrição?".
