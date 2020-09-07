module SalePostsHelper
  def cover_image(post, classes: '')
    return image_tag post.cover, alt: "#{post.title} capa", class: classes if post.cover.attached?

    image_tag 'no-image.jpg', alt: 'Anúncio sem foto', class: classes
  end

  def enable_disable_button(post)
    return link_to 'Desativar anúncio', disable_sale_post_path(post), method: :post if post.enabled?

    link_to 'Reativar anúncio', enable_sale_post_path(post), method: :post
  end
end
