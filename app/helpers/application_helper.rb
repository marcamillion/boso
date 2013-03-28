module ApplicationHelper
    class HTMLwithPygments < Redcarpet::Render::HTML
      def block_code(code, language)
        Pygments.highlight(code, lexer:language)
      end
    end
    
    def markdown(text)
        renderer = HTMLwithPygments.new(hard_wrap: true)
        options = {
          autolink: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          lax_html_blocks: true,
          strikethrough: true,
          superscript: true
        }
        Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
  
  

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

end
