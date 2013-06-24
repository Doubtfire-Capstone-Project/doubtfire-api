class ConvenorProjectTutorialsController < ApplicationController
  def index
    @convenor_projects = Unit.joins(:project_convenors)
                                        .where(project_convenors: {user_id: current_user.id})

    @unit = Unit.includes(:task_definitions).find(params[:id])
    
    @projects = Project.includes({
                  student: [:user, :tutorial],
                  tasks: [:task_definition]
                  }, :unit
                )
                .where(unit_id: params[:id])

    @projects.sort!{|a,b| a.student.user.name <=> b.student.user.name }

    @project_tutorials = @projects.map {|project|
      project.student.tutorial
    }.uniq
  end

  def show
    @convenor_projects = Unit.joins(:project_convenors)
                                        .where(project_convenors: {user_id: current_user.id})
    
    @unit = Unit.find(params[:unit_id])
    authorize! :read, @unit, message:  "You are not authorised to view Unit ##{@unit.id}"
    
    @tutorial             = Tutorial.find(params[:tutorial_id])
  end
end
