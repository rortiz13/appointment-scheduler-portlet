package com.tecnocom.csj.portlet;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import javax.mail.Session;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import co.com.tecnocom.csj.core.util.AuditUtil;
import co.com.tecnocom.csj.core.util.CommonDataUtil;
import co.com.tecnocom.csj.core.util.EmailUtil;
import co.com.tecnocom.csj.core.util.dto.Appointment;
import co.com.tecnocom.csj.core.util.dto.AppointmentConstants;
import co.com.tecnocom.csj.core.util.dto.City;
import co.com.tecnocom.csj.core.util.dto.Department;
import co.com.tecnocom.csj.core.util.properties.DatasourceProperties;

import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.kernel.captcha.CaptchaUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.mail.Account;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.ServiceContextThreadLocal;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portlet.calendar.model.CalEvent;
import com.liferay.portlet.calendar.model.CalEventConstants;
import com.liferay.portlet.calendar.service.CalEventLocalServiceUtil;
import com.liferay.portlet.dynamicdatalists.model.DDLRecord;
import com.liferay.portlet.dynamicdatalists.model.DDLRecordSet;
import com.liferay.portlet.dynamicdatalists.service.DDLRecordLocalServiceUtil;
import com.liferay.portlet.dynamicdatalists.service.DDLRecordSetLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet implementation class AppointmentSchedulerPortlet
 */
public class AppointmentSchedulerPortlet extends MVCPortlet {

	private Log _log = LogFactoryUtil.getLog(getClass());
	private static final String CACHE_LOCATION = "/html/static-mail-content/e-mail-content.html";
	public static final String NAME_REGEX = "^[\\sa-zñáéíóúü]]*[a-zñáéíóúü]+[\\sa-zñáéíóúü]*$";
	private static final SimpleDateFormat daySDF = new SimpleDateFormat("E dd - MM - yyyy");
	private static final SimpleDateFormat hourSDF = new SimpleDateFormat("hh:mm a");

	@Override
	public void init() throws PortletException {
		EmailUtil.INSTANCE.removeFromCache(CACHE_LOCATION);

		super.init();
	}

	public void createAppointment(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {

		// verifica el captcha ingresado
		if (!validateCaptcha(actionRequest)) {
			PortalUtil.copyRequestParameters(actionRequest, actionResponse);
			SessionErrors.add(actionRequest, "wrong-captcha");
			return;
		}

		if (!validateCreationFormAndCreate(actionRequest)) {
			PortalUtil.copyRequestParameters(actionRequest, actionResponse);
			return;
		}
	}

	public void deleteAppointment(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
		int recordId = ParamUtil.getInteger(actionRequest, "_recordIdToDelete", -1);
		_log.debug("recordId = " + recordId);
		_log.debug("parameters = " + actionRequest.getParameterMap());
		if (recordId > -1) {

			// Auditoria
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			AuditUtil.INSTANCE.auditResource(ServiceContextThreadLocal.getServiceContext(), getLayoutURL(themeDisplay), recordId, "Cancelar Cita", "tecnocom_citas");

			try {
				CommonDataUtil.INSTANCE.deleteAppointmentById(recordId, DatasourceProperties.INSTANCE.getLiferayDS());
			} catch (SQLException ex) {
				_log.error("unable to delete appointment with id = " + recordId);
				SessionErrors.add(actionRequest, "unable-to-delete-record");
				return;
			}
		}
	}

	public void acceptAppointment(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
		int recordId = ParamUtil.getInteger(actionRequest, "_recordIdToAccept", -1);

		int _minute = ParamUtil.getInteger(actionRequest, "_minute", 0);
		int _hour = ParamUtil.getInteger(actionRequest, "_hour", 0);
		int end_minute = ParamUtil.getInteger(actionRequest, "end_minute", 0);
		int end_hour = ParamUtil.getInteger(actionRequest, "end_hour", 0);
		_log.debug("recordId to accept: " + recordId);
		_log.debug("hour to accept: " + _hour);
		_log.debug("minute to accept: " + _minute);
		_log.debug("end_hour to accept: " + end_hour);
		_log.debug("end_minute to accept: " + end_minute);
		assert (end_hour >= _hour);
		if (recordId > -1) {
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

			Calendar recordCalendar = Calendar.getInstance();
			Appointment appointment = null;
			try {
				appointment = CommonDataUtil.INSTANCE.getAppointmentById(recordId, DatasourceProperties.INSTANCE.getLiferayDS());
			} catch (SQLException ex) {
				_log.error("unable to fetch appointment with id = " + recordId);
				SessionErrors.add(actionRequest, "unable-to-fetch-record");
				return;
			}
			recordCalendar.setTime(appointment.getStartDate());
			String nameAndLastName = appointment.getFullName();
			String comments = appointment.getComments();
			String email = appointment.getEmail();

			Calendar startDate = Calendar.getInstance();
			startDate.set(Calendar.HOUR_OF_DAY, _hour);// hourOfDay);
			startDate.set(Calendar.MINUTE, (int) (long) _minute);
			startDate.set(Calendar.DATE, recordCalendar.get(Calendar.DATE));
			startDate.set(Calendar.MONTH, recordCalendar.get(Calendar.MONTH));
			startDate.set(Calendar.YEAR, recordCalendar.get(Calendar.YEAR));

			// agrega una hora a partir de la hora de inicio de la cita
			Calendar endDate = (Calendar) startDate.clone();
			endDate.add(Calendar.HOUR_OF_DAY, 1);

			String appointmentDocuments = null;
			try {
				_log.info("Accepting Appointment: " + appointment.toString());
				
				DDLRecord record = DDLRecordLocalServiceUtil.fetchDDLRecord(appointment.getAppointmentTypeId());

				appointmentDocuments = (String) record.getField("process_documents").getValue();
				String[] documents = appointmentDocuments.split("\n");

				appointmentDocuments = StringUtil.merge(documents, "<br/>");

				ServiceContext serviceContext = ServiceContextFactory.getInstance(CalEvent.class.getName(), actionRequest);
				CalEventLocalServiceUtil.addEvent(themeDisplay.getUserId(), nameAndLastName, // event
																								// title
						comments, // event description
						LocaleUtil.toLanguageId(themeDisplay.getLocale()), // event
																			// locale
						startDate.get(Calendar.MONTH), startDate.get(Calendar.DATE), startDate.get(Calendar.YEAR), startDate.get(Calendar.HOUR_OF_DAY), startDate.get(Calendar.MINUTE),

						startDate.get(Calendar.MONTH), // end date month
						startDate.get(Calendar.DATE), // end date day
						startDate.get(Calendar.YEAR), // end date year

						end_hour - _hour, // duration hour
						end_minute - _minute, // duration minute
						false, // all day
						false, // time zone sensitive
						"appointment", false, // repeating

						null, // recurrence
						CalEventConstants.REMIND_BY_NONE, // remind by
						0, // first reminder
						0, // second reminder
						serviceContext);
			} catch (PortalException e) {
				SessionErrors.add(actionRequest, "unable-to-create-calendar-event");
				_log.error("unable to create the calendar event", e);
			} catch (SystemException e) {
				SessionErrors.add(actionRequest, "unable-to-create-calendar-event");
				_log.error("unable to create the calendar event", e);
			}

			HttpServletRequest request = PortalUtil.getHttpServletRequest(actionRequest);
			ServletContext servletContext = request.getSession().getServletContext();
			
			try {
				Session session = MailServiceUtil.getSession();
				String protocol = GetterUtil.getString(session.getProperty("mail.transport.protocol"), Account.PROTOCOL_SMTP);
				String emailFrom = session.getProperty("mail." + protocol + ".user");
				
				EmailUtil.INSTANCE.sendEmail(/*
											 * themeDisplay.getUser().getEmailAddress
											 * ()
											 */emailFrom, email, "Su cita ha sido agendada", servletContext, CACHE_LOCATION, new String[] { daySDF.format(startDate.getTime()), hourSDF.format(startDate.getTime()),
						hourSDF.format(endDate.getTime()), appointmentDocuments });
			} catch (Exception ex) {
				_log.error("Unable to send appointment email");
				_log.error("Exception", ex);
			}
			
			// Auditoria
			AuditUtil.INSTANCE.auditResource(ServiceContextThreadLocal.getServiceContext(), getLayoutURL(themeDisplay), recordId, "Aceptar Cita", "tecnocom_citas");

			try {
				CommonDataUtil.INSTANCE.deleteAppointmentById(recordId, DatasourceProperties.INSTANCE.getLiferayDS());
			} catch (SQLException ex) {
				_log.error("unable to delete appointment with id = " + recordId);
				SessionErrors.add(actionRequest, "unable-to-delete-record");
				return;
			}
		} else {
			throw new IllegalArgumentException("recordId must be greater than -1");
		}
	}

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		boolean isGuest = themeDisplay.getUser().isDefaultUser();

		_log.info(themeDisplay.getScopeGroupId());

		List<CalEvent> appointmentEvents = Collections.<CalEvent> emptyList();
		if (isGuest) {
			renderRequest.setAttribute("departments", CommonDataUtil.INSTANCE.getDepartmentsAndCities(DatasourceProperties.INSTANCE.getLiferayDS()).values());

			PortletPreferences preferences;
			String appointmentTypeListId = StringPool.BLANK;
			try {
				preferences = PortletPreferencesFactoryUtil.getPortletSetup(renderRequest);
				appointmentTypeListId = preferences.getValue(APPOINTMENT_TYPE_DDL_RECORD_KEY, StringPool.BLANK);
			} catch (PortalException e1) {
				_log.error("error obteniendo las preferencias del portlet", e1);
			} catch (SystemException e1) {
				_log.error("error obteniendo las preferencias del portlet", e1);
			}

			if (!appointmentTypeListId.isEmpty()) {
				try {

					DDLRecordSet ddlAppointmentTypeRecordSet = DDLRecordSetLocalServiceUtil.fetchDDLRecordSet(Long.valueOf(appointmentTypeListId));
					if (_log.isDebugEnabled()) {
						_log.debug(ddlAppointmentTypeRecordSet.getRecords().size());
					}

					renderRequest.setAttribute("appointmentTypesDDL", ddlAppointmentTypeRecordSet.getRecords());
				} catch (NumberFormatException e) {
					_log.error("el id de la lista dínamica no tiene el formato apropiado: id = " + appointmentTypeListId, e);
				} catch (SystemException e) {
					_log.error("excepción obteniendo la lista de datos dínamica con id = " + appointmentTypeListId, e);
				}

			}

		} else {
			try {
				_log.info(DatasourceProperties.INSTANCE.getLiferayDS());
				renderRequest.setAttribute("appointmentRequests", CommonDataUtil.INSTANCE.getAllAppointments(themeDisplay.getScopeGroupId(), DatasourceProperties.INSTANCE.getLiferayDS()));
			} catch (Exception ex) {
				renderRequest.setAttribute("appointmentRequests", Collections.<Appointment> emptyList());
				_log.debug("error obtaining appointmentRequests", ex);
			}
			try {
				ServiceContext serviceContext = ServiceContextFactory.getInstance(CalEvent.class.getName(), renderRequest);
				appointmentEvents = CalEventLocalServiceUtil.getEvents(serviceContext.getScopeGroupId(), "appointment", 0, CalEventLocalServiceUtil.getEventsCount(serviceContext.getScopeGroupId(), "appointment"));
				renderRequest.setAttribute("appointmentEvents", appointmentEvents);
			} catch (SystemException e) {
				_log.error("an error ocurred obtaining the calendar events", e);
			} catch (PortalException e) {
				_log.error("an error ocurred obtaining the calendar events", e);
			}
		}

		super.doView(renderRequest, renderResponse);
	}

	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortletException {

		Integer departmentCode = ParamUtil.getInteger(resourceRequest, "departmentCode", -1);
		if (departmentCode < 0) {
			CaptchaUtil.serveImage(resourceRequest, resourceResponse);
			return;
		}
		// PortletSession portletSession = resourceRequest.getPortletSession();
		JSONArray jArray = JSONFactoryUtil.createJSONArray();
		Department department = CommonDataUtil.INSTANCE.getDepartmentsAndCities(DatasourceProperties.INSTANCE.getLiferayDS()).get(departmentCode);
		Collection<City> cities = department.getCities().values();
		for (City city : cities) {
			jArray.put(JSONFactoryUtil.createJSONObject().put("code", city.getCode()).put("name", city.getName()));
		}

		JSONObject jResponse = JSONFactoryUtil.createJSONObject();
		jResponse.put("cities", jArray);

		resourceResponse.getWriter().write(jResponse.toString());
		super.serveResource(resourceRequest, resourceResponse);
	}

	private boolean validateCaptcha(PortletRequest request) {
		String userCaptcha = ParamUtil.getString(request, "captchaText", StringPool.BLANK).trim();
		PortletSession portletSession = request.getPortletSession();
		String captchaValue = (String) portletSession.getAttribute("CAPTCHA_TEXT");
		captchaValue = captchaValue == null ? StringPool.BLANK : captchaValue.trim();
		if (captchaValue.equalsIgnoreCase(userCaptcha)) {
			return true;
		}
		return false;
	}

	private boolean validateCreationFormAndCreate(PortletRequest request) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		int departmentCode = ParamUtil.getInteger(request, "appointment-department", 0);
		int cityCode = ParamUtil.getInteger(request, "appointment-city", 0);
		long appointmentTypeId = ParamUtil.getLong(request, "appointment-type", 0L);
		int dateDay = ParamUtil.getInteger(request, "appointment-dateday", 0);
		int dateMonth = ParamUtil.getInteger(request, "appointment-datemonth", 0);
		int dateYear = ParamUtil.getInteger(request, "appointment-dateyear", 0);
		int appointmentHours = ParamUtil.getInteger(request, "appointment-hour", 0);
		String fullName = ParamUtil.getString(request, "contact-name-and-last-name", StringPool.BLANK).trim();
		String phone = ParamUtil.getString(request, "contact-phone", StringPool.BLANK).trim();
		String email = ParamUtil.getString(request, "contact-email", StringPool.BLANK).trim();

		// valida que el departamento exista
		if (!CommonDataUtil.INSTANCE.getDepartmentsAndCities(DatasourceProperties.INSTANCE.getLiferayDS()).containsKey(departmentCode)) {
			SessionErrors.add(request, "invalid-department");
			return false;
		}

		// valida que la ciudad exista
		if (!CommonDataUtil.INSTANCE.getDepartmentsAndCities(DatasourceProperties.INSTANCE.getLiferayDS()).get(departmentCode).getCities().containsKey(cityCode)) {
			SessionErrors.add(request, "invalid-city");
			return false;
		}
		City city = CommonDataUtil.INSTANCE.getDepartmentsAndCities(DatasourceProperties.INSTANCE.getLiferayDS()).get(departmentCode).getCities().get(cityCode);

		if (AppointmentConstants.values().length < appointmentHours) {
			SessionErrors.add(request, "invalid-appointment-hours");
			return false;
		}

		if (!Validator.isAddress(email)) {
			SessionErrors.add(request, "invalid-email");
			return false;
		}

		// valida que el nombre este compuesto de almenos una letra
		if (!fullName.matches("(?i)" + NAME_REGEX)) {
			SessionErrors.add(request, "invalid-name");
			return false;
		}

		if (!Validator.isDigit(phone)) {
			SessionErrors.add(request, "invalid-phone");
			return false;
		}

		PortletPreferences preferences = request.getPreferences();
		String appointmentTypePrefsID = preferences.getValue(APPOINTMENT_TYPE_DDL_RECORD_KEY, StringPool.BLANK);
		try {
			DDLRecordSet recordSet = DDLRecordSetLocalServiceUtil.fetchDDLRecordSet(Long.valueOf(appointmentTypePrefsID));
			DDLRecord record = DDLRecordLocalServiceUtil.fetchDDLRecord(appointmentTypeId);
			// verifica que el id seleccionado para el tipo de cita este dentro
			// de los registros de la lista
			if (recordSet.getRecordSetId() == record.getRecordSetId()) {
				;
			} else {
				SessionErrors.add(request, "invalid-appointment-type");
				return false;
			}

		} catch (NumberFormatException e1) {
			_log.error("error de formato de número: appointmentTypeId = " + appointmentTypeId + ", appointmentTypePrefsID = " + appointmentTypePrefsID);
			SessionErrors.add(request, "invalid-appointment-type");
			return false;
		} catch (SystemException e1) {
			_log.error("error obteniendo DDLRecordSet con id " + appointmentTypePrefsID + ", DDLRecord con id " + appointmentTypeId);
			SessionErrors.add(request, "invalid-appointment-type");
			return false;
		}

		// valida que la fecha sea almenos 5 dias despues del dia de hoy
		Calendar referenceDate = Calendar.getInstance();
		referenceDate.add(Calendar.DAY_OF_MONTH, 5);

		Calendar startDate = Calendar.getInstance();
		startDate.set(Calendar.DAY_OF_MONTH, dateDay);
		startDate.set(Calendar.MONTH, dateMonth);
		startDate.set(Calendar.YEAR, dateYear);

		if (referenceDate.after(startDate)) {
			SessionErrors.add(request, "invalid-date");
			return false;
		}
		String comments = ParamUtil.getString(request, "comments", StringPool.BLANK);
		try {
			CommonDataUtil.INSTANCE.createAppointmentDirectly(fullName, phone, email, comments, appointmentHours, city.getId(), appointmentTypeId, startDate.getTime(), themeDisplay.getScopeGroupId(),
					DatasourceProperties.INSTANCE.getLiferayDS());
		} catch (SQLException e) {
			_log.error("could not insert database record with values { cityId = " + city.getId() + ", appointmentTypeId = " + appointmentTypeId + "}", e);
			SessionErrors.add(request, "Ha ocurrido un error creando la cita. Intente de nuevo más tarde.");
		}
		return true;
	}

	public void editPreferences(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
		long appointmentTypeListId = ParamUtil.getLong(actionRequest, "appointment-type-dynamic-data-list-id", 0L);
		_log.info(appointmentTypeListId);

		try {
			PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest);
			preferences.setValue(APPOINTMENT_TYPE_DDL_RECORD_KEY, String.valueOf(appointmentTypeListId));
			preferences.store();
		} catch (PortalException e) {
			_log.error("error obteniendo las preferencias del portlet", e);
		} catch (SystemException e) {
			_log.error("error obteniendo las preferencias del portlet", e);
		}
	}

	public static final String APPOINTMENT_TYPE_DDL_RECORD_KEY = "appointment-dynamic-data-list-id";

	private String getLayoutURL(ThemeDisplay themeDisplay) {
		try {
			return PortalUtil.getLayoutURL(themeDisplay);
		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}

		return "";
	}
}
