class Ckeditor::PicturesController < Ckeditor::ApplicationController
  before_filter :load_app

  def index
    @pictures = Ckeditor.picture_adapter.find_all(ckeditor_pictures_scope(app_id: @app.id))
    @pictures = Ckeditor::Paginatable.new(@pictures).page(params[:page])
    
    respond_with(@pictures, :layout => @pictures.first_page?) 
  end
  
  def create
    @picture = Ckeditor.picture_model.new(app_id: @app.id)
	  respond_with_asset(@picture)
  end
  
  def destroy
    @picture.destroy
    respond_with(@picture, :location => pictures_path)
  end
  
  protected
  
    def find_asset
      @picture = Ckeditor.picture_adapter.get!(params[:id])
    end

    def authorize_resource
      model = (@picture || Ckeditor.picture_model)
      @authorization_adapter.try(:authorize, params[:action], model)
    end

    def load_app
      @app = current_user.apps.find(session[:app_id])
      rescue
        raise 'The App could not be found or you do not have permission to manage it.'
    end
end
