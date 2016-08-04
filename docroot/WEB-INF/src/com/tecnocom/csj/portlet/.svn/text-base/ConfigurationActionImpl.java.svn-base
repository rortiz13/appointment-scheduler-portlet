package com.tecnocom.csj.portlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;

public class ConfigurationActionImpl implements ConfigurationAction{
	private Log _log = LogFactoryUtil.getLog(getClass());
	
	@Override
	public void processAction(PortletConfig portletConfig,
			ActionRequest actionRequest, ActionResponse actionResponse)
			throws Exception {
		String appointment_dynamic_data_list_id = ParamUtil.getString(actionRequest, "appointment-dynamic-data-list-id");
		String city_dynamic_data_list_id = ParamUtil.getString(actionRequest, "city-dynamic-data-list-id");
		String appointment_type_dynamic_data_list_id = ParamUtil.getString(actionRequest, "appointment-type-dynamic-data-list-id");
		
		
		String portletResource = ParamUtil.getString(actionRequest, "portletResource");
		
		PortletPreferences prefs = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);
		
		if(_log.isDebugEnabled()){
			String preference_appointment_dynamic_data_list_id = prefs.getValue("appointment-dynamic-data-list-id", "0");
			String preference_city_dynamic_data_list_id = prefs.getValue("city-dynamic-data-list-id", "0");
			String preference_appointment_type_dynamic_data_list_id = prefs.getValue("appointment-type-dynamic-data-list-id", "0");
			
			_log.debug("prefs appointment-dynamic-data-list-id = " + preference_appointment_dynamic_data_list_id);
			_log.debug("prefs city-dynamic-data-list-id = " + preference_city_dynamic_data_list_id);
			_log.debug("prefs appointment-type-dynamic-data-list-id = " + preference_appointment_type_dynamic_data_list_id);
			
			
			_log.debug("form appointment-dynamic-data-list-id = " + appointment_dynamic_data_list_id);
			_log.debug("form city-dynamic-data-list-id = " + city_dynamic_data_list_id);
			_log.debug("form appointment-type-dynamic-data-list-id = " + appointment_type_dynamic_data_list_id);
		}
		
		prefs.setValue("appointment-dynamic-data-list-id", appointment_dynamic_data_list_id);
		prefs.setValue("city-dynamic-data-list-id", city_dynamic_data_list_id);
		prefs.setValue("appointment-type-dynamic-data-list-id", appointment_type_dynamic_data_list_id);
		
		prefs.store();
	}

	@Override
	public String render(PortletConfig portletConfig,
			RenderRequest renderRequest, RenderResponse renderResponse)
			throws Exception {
		return "/html/appointmentscheduler/configuration.jsp";
	}

}
