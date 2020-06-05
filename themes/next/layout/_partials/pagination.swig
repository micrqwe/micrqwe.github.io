{% if page.prev or page.next %}
  <nav class="pagination">
    {{
      paginator({
        prev_text: '首页',
        next_text: '尾页',
        mid_size: 1
      })
    }}
  </nav>
{% endif %}
