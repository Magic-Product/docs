from pathlib import Path

from mkdocs.plugins import event_priority


KROKI_SOURCES = {
    "@from_file:architecture/workspace.dsl": "architecture/workspace.dsl",
}


@event_priority(100)
def on_page_markdown(markdown: str, config, **kwargs) -> str:
    """Inline UTF-8 Kroki sources before mkdocs-kroki-plugin processes them."""
    docs_dir = Path(config.docs_dir)

    for directive, relative_path in KROKI_SOURCES.items():
        if directive in markdown:
            source = (docs_dir / relative_path).read_text(encoding="utf-8")
            markdown = markdown.replace(directive, source.rstrip())

    return markdown
