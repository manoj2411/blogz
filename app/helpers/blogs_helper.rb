module BlogsHelper

  def render_blog_status_for_current_user(blog)
    if current_user and current_user.can_update_status?(blog)
      render('publish_status_form', blog: blog)
    else
      link_to(blog.status, 'javascript:void(0)', class: 'btn btn-primary btn-sm', disabled: :disabled)
    end
  end
end
