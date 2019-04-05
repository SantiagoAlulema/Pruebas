require 'fileutils'
class FormulariosController < ApplicationController
  before_action :set_formulario, only: [:show, :edit, :update, :destroy, :download, :download_later]

  # GET /formularios
  # GET /formularios.json
  def index
    @formularios = Formulario.search
    @select_options = Formulario.get_name_folder
  end

  # GET /formularios/1
  # GET /formularios/1.json
  def show
    respond_to do |format|
      format.html
      format.js
    end
    extension = @formulario.title.split('.')
    #send_file Rails.root.join('public','Archivos','procesos','avaluo', @formulario.title),
    #:type=>"application/#{extension[1]}", :x_sendfile=>true
  end

  def download
    extension = File.extname(@formulario.title)
    category = Formulario::REFERENCES_CATEGORY[@formulario.categoria]

    send_file(Rails.root.join(Formulario::ROUTE_PATH, category, @formulario.title),
              :type=>"application/#{extension}", :x_sendfile=>true)

  end

  def download_later
    redirect_later download_formulario(@formulario), "Download starts in %d seconds."
  end

  # GET /formularios/new
  def new
    @formulario = Formulario.new
    @select_options = Formulario.get_name_folder
  end

  # GET /formularios/1/edit
  def edit
  end

  # POST /formularios
  # POST /formularios.json
  def create
    @formulario = Formulario.new(formulario_params)
    if params[:formulario][:categoria].present?
      category = Formulario::REFERENCES_CATEGORY[params[:formulario][:categoria]]
      uploaded_io= params[:formulario][:title].tempfile
      #File.open(Rails.root.join("#{Formulario::ROUTE_PATH}",category, uploaded_io.original_filename), 'wb') do |file|
      #  file.write(uploaded_io)
      #end
      file = File.join("#{Formulario::ROUTE_PATH}",category, params[:formulario][:title].original_filename)
      FileUtils.cp uploaded_io.path, file
      #FileUtils.rm file
      @formulario.title= params[:formulario][:title].original_filename
    end
    respond_to do |format|
      if @formulario.save
        format.html { redirect_to @formulario, notice: 'Formulario was successfully created.' }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, alert: "An error has ocurred" }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /formularios/1
  # PATCH/PUT /formularios/1.json
  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to @formulario, notice: 'Formulario was successfully updated.' }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /formularios/1
  # DELETE /formularios/1.json
  def destroy
    category = Formulario::REFERENCES_CATEGORY[@formulario.categoria]
    file = File.join("#{Formulario::ROUTE_PATH}",category, @formulario.title)
    FileUtils.rm file
    @formulario.destroy
    respond_to do |format|
      puts "----------> #{formularios_url}"
      format.html { redirect_to formularios_url, notice: 'Formulario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @formularios = Formulario.search(params[:search])
    @select_options = Formulario.get_name_folder
    puts ">>>>>>> #{@formularios}"
    respond_to :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def formulario_params
      params.require(:formulario).permit(:id, :title, :cover_letter, :categoria)
    end
end
