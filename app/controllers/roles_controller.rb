class RolesController < PrivateAccessController
  def update
    @variable = Variable.find(params[:dictionary_id])
    @role = Role.find(params[:id])

    if @variable.roles.exists?(@role.id)
      @variable.roles.destroy(@role)

      respond_to do |format|
        format.js
      end
    else
      @variable.roles << @role
      respond_to do |format|
        format.js
      end
    end
  end
end
