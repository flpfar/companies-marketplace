module SalePostsHelper
  def cover_image(post, classes: '')
    return image_tag post.cover, alt: "#{post.title} capa", class: classes if post.cover.attached?

    image_tag 'no-image.jpg', alt: 'Anúncio sem foto', class: classes
  end
end
