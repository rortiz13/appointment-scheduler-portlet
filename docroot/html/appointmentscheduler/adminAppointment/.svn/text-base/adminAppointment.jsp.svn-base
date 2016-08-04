<%@page import="com.liferay.portal.kernel.util.CalendarUtil"%>
<%@page import="com.liferay.portal.kernel.util.Time"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liferay.portlet.dynamicdatamapping.storage.Fields"%>
<%@ include file="../../init.jsp" %>


<liferay-ui:error key="unable-to-fetch-record" message="unable-to-fetch-record"/>
<liferay-ui:error key="unable-to-delete-record" message="unable-to-delete-record"/>

<c:if test='${ not isGuest }'>
<% //if(/*!isGuest*/true){ 
	SimpleDateFormat sdf = new SimpleDateFormat("dd - MM - yyyy");
	List<CalEvent> appointmentEvents = (List<CalEvent>) renderRequest.getAttribute("appointmentEvents");
	List<Appointment> appointmentRequests = (List<Appointment>) renderRequest.getAttribute("appointmentRequests");
	StringBuilder morningOptions = new StringBuilder(String.format("<optgroup label='%s'>", LanguageUtil.get(portletConfig, locale, "morning")));
	for(int i = 8; i < 12; i++){
		morningOptions.append(String.format("<option value='%d'>%d</option>", i, i));
	}
	morningOptions.append("</optgroup>");
	
	StringBuilder afternoonOptions = new StringBuilder(String.format("<optgroup label='%s'>", LanguageUtil.get(portletConfig, locale, "afternoon")));
	for(int i = 12; i < 17; i++){
		afternoonOptions.append(String.format("<option value='%d'>%d</option>",i, i%12));
	}
	afternoonOptions.append("</optgroup>");
	
	StringBuilder events = new StringBuilder("[");
	for(CalEvent event: appointmentEvents){
		Calendar startCal = Calendar.getInstance();
		startCal.setTime(event.isTimeZoneSensitive() ? Time.getDate(event.getStartDate(), timeZone) : event.getStartDate());
		Calendar endCal = Calendar.getInstance();
		endCal.setTime(event.isTimeZoneSensitive() ? Time.getDate(getEndTime(event), timeZone) : getEndTime(event));
		String eventJSON = String.format(",{content: \"%s\", endDate: new Date(%d, %d, %d, %d, %d), startDate: new Date(%d, %d, %d, %d, %d)}",
				HtmlUtil.escapeJS(event.getTitle()),	// contenido
				
				endCal.get(Calendar.YEAR),				// datos de la fecha de finalizacion
				endCal.get(Calendar.MONTH),
				endCal.get(Calendar.DATE),
				endCal.get(Calendar.HOUR_OF_DAY),
				endCal.get(Calendar.MINUTE),
				
				startCal.get(Calendar.YEAR),			// datos de la fecha de inicio
				startCal.get(Calendar.MONTH),
				startCal.get(Calendar.DATE),
				startCal.get(Calendar.HOUR_OF_DAY),
				startCal.get(Calendar.MINUTE)
				);
		events.append(eventJSON);
	}
	events.append("]");
%>

<aui:layout>
	<aui:column columnWidth="40">
	<form name="deleteAppointmentForm" id='deleteAppointmentForm' action='<portlet:actionURL name="deleteAppointment"></portlet:actionURL>' method='post'>
		<input type="hidden" id='<portlet:namespace/>_recordIdToDelete' name="_recordIdToDelete" value='0'/>
	</form>
	<form name="acceptAppointmentForm" id='acceptAppointmentForm' action='<portlet:actionURL name="acceptAppointment"></portlet:actionURL>' method='post'>
		<input type="hidden" id='<portlet:namespace/>_recordIdToAccept' name="_recordIdToAccept" value='0'/>
		<input type="hidden" id='<portlet:namespace/>_hour' name="_hour" value='0'/>
		<input type="hidden" id='<portlet:namespace/>_minute' name="_minute" value='0'/>
		<input type="hidden" id='<portlet:namespace/>end_hour' name="end_hour" value='0'/>
		<input type="hidden" id='<portlet:namespace/>end_minute' name="end_minute" value='0'/>
	</form>
	<h5 class='appointment-blue appointment-underlined'><liferay-ui:message key='requests'/></h5>
		
		
		
		
		
		
		
		
		<liferay-ui:search-container delta="5" emptyResultsMessage="appointment-records-empty-or-not-set">
			<liferay-ui:search-container-results results="<%= appointmentRequests.subList(searchContainer.getStart(), searchContainer.getEnd()>appointmentRequests.size()? appointmentRequests.size():searchContainer.getEnd()) %>" total="<%= appointmentRequests.size() %>"/>
			
			<liferay-ui:search-container-row
				className="co.com.tecnocom.csj.core.util.dto.Appointment"
				keyProperty="id"
				modelVar="record"
			>
			<%	
				Appointment $fields = record;
				String $contact_name_and_last_name = $fields.getFullName();
				Date $appointment_date = $fields.getStartDate();
				AppointmentConstants $appointment_hour = $fields.getAppointmentHours();
				String $comments = $fields.getComments();
			%>
			<div id='ddl-record-<%= record.getId() %>'>
				<div class="aui-helper-hidden">
					<div id="modal">
						<aui:column columnWidth='100'>
							<div id='separator' style='height: 10px'></div>
						</aui:column>
						<aui:column columnWidth='100'>
							<h5>
								<liferay-ui:message key='init-hour'/>
							</h5>
						</aui:column>
						<aui:column columnWidth='50'>
							<aui:select id="hour" name="hour">
								<% if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_MORNING){
									// solo horas antes del medio dia
									out.println(morningOptions.toString());
								} else if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_AFTERNOON){
									// solo horas despues del medio dia
									out.println(afternoonOptions.toString());
								} else{
									// horas de antes y despues del medio dia
									out.println(morningOptions.toString());
									out.println(afternoonOptions.toString());
								}
									%>
							</aui:select>
						</aui:column>
						<aui:column columnWidth='50'>
							<aui:select id='minute' name='minute'>
								<% for(int i = 0; i< 60; i++){
									out.println(String.format("<option value='%d'>%d</option>", i, i));
								} %>
							</aui:select>
						</aui:column>
						<aui:column columnWidth='100'>
							<div id='separator' style='height: 10px'></div>
						</aui:column>
						
						<aui:column columnWidth='100'>
							<h5>
								<liferay-ui:message key='end-hour'/>
							</h5>
						</aui:column>
						
						<aui:column columnWidth='50'>
							<aui:select id="end-hour" name="end-hour" label="hour">
								<% if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_MORNING){
									// si se agenda por la mañana puede terminar en la tarde tambien
									out.println(morningOptions.toString());
									out.println(afternoonOptions.toString());
								} else if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_AFTERNOON){
									// si se agenda en la tarde solo puede terminar en la tarde
									out.println(afternoonOptions.toString());
								} else{
									// si se agenda en cualquier horario puede terminar en cualquier horario
									out.println(morningOptions.toString());
									out.println(afternoonOptions.toString());
								}
									%>
							</aui:select>
						</aui:column>
						<aui:column columnWidth='50'>
							<aui:select id='end-minute' name='end-minute' label="minute">
								<% for(int i = 0; i< 60; i++){
									out.println(String.format("<option value='%d'>%d</option>", i, i));
								} %>
							</aui:select>
						</aui:column>
						
						
						<aui:column columnWidth='100'>
							<div id='separator' style='height: 10px'></div>
						</aui:column>
						<aui:column columnWidth='100'>
							<button onclick='confirmEventAccept(<%= record.getId() %>)' type='button' class='appointment-button'>
								<liferay-ui:message key="confirm"/>
							</button>
						</aui:column>
				  	</div>
				</div>
				<aui:column columnWidth='100'>
					<aui:column columnWidth="50">
				        <div class='appointment-name-and-hour'>
				            <div class='appointment-tittle'><liferay-ui:message key='name'/>:</div>
							<div><%= $contact_name_and_last_name %></div>
				            <div class='appointment-tittle'><liferay-ui:message key='appointment-hours'/>:</div>
							<div>
								<% if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_MORNING){
									out.println(LanguageUtil.get(portletConfig, locale, "morning"));
								} else if($appointment_hour == AppointmentConstants.APPOINTMENT_SCHEDULE_AFTERNOON){
									out.println(LanguageUtil.get(portletConfig, locale, "afternoon"));
								} else{
									out.println(LanguageUtil.get(portletConfig, locale, "any"));
								}
								%>
							</div>
				        </div>
			        </aui:column>
			        <aui:column columnWidth="50">
				        <div class='appointment-date'>
				            <div class='appointment-tittle'><liferay-ui:message key='request-date'/>:</div>
							<div><%= sdf.format($appointment_date) %></div>
				        </div>
			        </aui:column>
		        </aui:column>
				<aui:column columnWidth='100'>
		            <div class='appointment-tittle'><liferay-ui:message key="comments"/>:</div>
					<div><%= $comments %></div>
				</aui:column>
				<aui:button-row>
					<button onclick='triggerLiferayEventReject(<%= record.getId() %>)' type='button' class='appointment-button'>
						<liferay-ui:message key="reject"/>
					</button>
					<button onclick='triggerLiferayEventAccept(<%= record.getId() %>)' type='button' class='appointment-button'>
						<liferay-ui:message key="accept"/>
					</button>
				</aui:button-row>
		    </div>
			<hr/>
			</liferay-ui:search-container-row>
			
			<liferay-ui:search-iterator />
		</liferay-ui:search-container>
		
		
		
		
		
		
		
		
	<script type="text/javascript">
		function triggerLiferayEventAccept(id){
			AUI().use('aui-dialog', function(A){
				var dialog = new A.Dialog({
		            title: '<liferay-ui:message key="appointment-hours"/>',
		            centered: true,
		            modal: true,
		            width: 200,
		            height: 230,
		            resizable: false,
		            bodyContent: '<div class="floating">' + A.one('#ddl-record-' + id + ' #modal').html() + '</div>',
		            destroyOnClose: true
		        }).render();
			});
		}
		
		function triggerLiferayEventReject(id){
			AUI().use(function(A){
				A.one('#<portlet:namespace/>_recordIdToDelete').val(id);
				A.one("#deleteAppointmentForm").submit();
			});
		}
		
		function confirmEventAccept(id){
			AUI().use(function(A){
				A.one('#<portlet:namespace/>_recordIdToAccept').val(id);
				
				var initHour = A.one('.floating #<portlet:namespace/>hour').val();
				var initMinute = A.one('.floating #<portlet:namespace/>minute').val();
				
				var endHour = A.one('.floating #<portlet:namespace/>end-hour').val();
				var endMinute = A.one('.floating #<portlet:namespace/>end-minute').val();
				
				// las fechas se inicializan con el mismo valor
				var initDate = new Date();
				var endDate = new Date(initDate.getTime());
				
				initDate.setHours(parseInt(initHour, 10));
				initDate.setMinutes(parseInt(initMinute, 10));
				
				endDate.setHours(parseInt(endHour, 10));
				endDate.setMinutes(parseInt(endMinute, 10));
				
				if(endDate.getTime() <= initDate.getTime()){
					alert('<liferay-ui:message key="end-hour-must-be-after-init-hour"/>');
					return;
				}
				
				A.one('#<portlet:namespace/>_hour').val(initHour);
				A.one("#<portlet:namespace/>_minute").val(initMinute);
				A.one('#<portlet:namespace/>end_hour').val(endHour);
				A.one("#<portlet:namespace/>end_minute").val(endMinute);
				
				A.one("#acceptAppointmentForm").submit();
			});
		}
	</script>
</aui:column>
<aui:column columnWidth='60'>
	<h5 class='appointment-blue appointment-underlined'><liferay-ui:message key='assigned-appointments'/></h5>
	<div id='scheduler-wrapper'>
		<div id='scheduler-content'></div>
	</div>
	<script type="text/javascript">
		AUI().ready("intl", 'lang/datatype-date-format_es-CO', 'aui-scheduler', function(A){
			// asignacion del lenguaje para los mensajes de alloy como es-CO
			A.Intl.setLang("datatype-date-format", "es-CO");
			var events = <%= events.toString().replaceFirst("^\\[,", "[") %>;
			var monthView = new A.SchedulerMonthView();
		    var dayView = new A.SchedulerDayView();
		    var weekView = new A.SchedulerWeekView();
			
			var eventRecorder = new A.SchedulerEventRecorder(
				{
					disabled:true,
					repeated:false,
					strings:{
						'description-hint': '<liferay-ui:message key="no-events-today"/>',
						cancel:'<liferay-ui:message key="close"/>'
					}
				}
			);
		    
			var objetoScheduler = new A.Scheduler({
				activeView: monthView,
				boundingBox: '#scheduler-content',
				eventRecorder: eventRecorder,
				events: events,
				views: [monthView, dayView, weekView],
				strings:{
					today:'Hoy',
					day:'Día',
					month:'Mes',
					week:'Semana',
					year:'Año'
				}
			}).render();
			
			// ejemplo de un evento que se agrega al scheduler
			//objetoScheduler.addEvent({content:'asdasd', endDate: new Date(2013, 8, 15, 19), startDate: new Date(2013, 8, 15, 8)})
			
			// metodo que debe llamarse luego de haber agregado un evento para que este se muestre
			//objetoScheduler.syncEventsUI();
		});
	</script>
</aui:column>
</aui:layout>
<%!
	Date getEndTime(CalEvent event) {
		long startTime = event.getStartDate().getTime();

		long endTime = startTime + (Time.HOUR * event.getDurationHour())
				+ (Time.MINUTE * event.getDurationMinute());

		return new Date(endTime);
	}
%>
</c:if>
