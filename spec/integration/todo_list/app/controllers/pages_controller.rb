class PagesController < Bijou::BaseController
  def index
    @agendas = Agenda.all.reverse
  end
end
