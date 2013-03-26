# This file is part of the OpenWISP Geographic Monitoring
#
# Copyright (C) 2012 OpenWISP.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class PropertySetsController < ApplicationController
  before_filter :authenticate_user!, :load_wisp, :load_access_point

  access_control do
    default :deny

    actions :update, :update_favourite do
      allow :wisps_viewer
      allow :wisp_access_points_viewer, :of => :wisp, :if => :wisp_loaded?
    end
  end
  
  def update
    if request.xhr?
      @property_set = @access_point.properties
      attr, val = params[:property_set].first # For security, restrict only one attribute at a time
      status = @property_set.update_attributes({attr => val}) ? :ok : :unprocessable_entity

      # In case a boolean field is updated, translate!
      val = I18n.t(val) if val == 'true' || val == 'false'
      
      render :text => val, :status => status
    else
      render :nothing => true, :status => :not_acceptable
    end
  end

  def update_favourite
    @property_set = @access_point.properties
    @property_set.update_attributes(:favourite => '0' )
    respond_to do |format|
       format.html { redirect_to wisp_access_points_path }
    end
  end
    
   


  private

  def load_access_point
    @access_point = @wisp.access_points.find params[:access_point_id]
  end
end
