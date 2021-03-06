<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务选择器</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
	    	$('#contentTable thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('check');
	    	});
	    	$('#contentTable thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
	    	});
		});		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }		
		function getSelectedItem(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			if(size == 0 ){
				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}

			if(size > 1 ){
				top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}
			var id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");
			var label = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".codelabel").html();
			return id+"_item_"+label;
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaTask" action="${ctx}/oa/oaTask/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>任务编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>任务名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>任务类型：</span>
									<form:select path="relationType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('relation_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>截止日期：</span>
									<input name="beginEndDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaTask.beginEndDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endEndDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaTask.endEndDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>优先级：</span>
									<form:select path="levelType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${oaTask.ownBy.id}" labelName="ownBy.name" labelValue="${oaTask.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>任务状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('task_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${oaTask.createBy.id}" labelName="createBy.name" labelValue="${oaTask.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaTask.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaTask.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">任务编号</th>
							<th class="sort-column name">任务名称</th>
							<th class="sort-column relation_type">任务类型</th>
							<th class="sort-column relation_name">关联名称</th>
							<th class="sort-column end_date">截止日期</th>
							<th class="sort-column level_type">优先级</th>
							<th class="sort-column schedule">进度</th>
							<th class="sort-column own_by">负责人</th>
							<th class="sort-column status">任务状态</th>
							<th class="sort-column create_by">创建者</th>
							<th class="sort-column create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaTask">
						<tr>
							<td><input type="checkbox" id="${oaTask.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看任务', '${ctx}/oa/oaTask/view?id=${oaTask.id}','800px', '500px')">${oaTask.no}</a></td>
							<td class="codelabel">${oaTask.name}</td>
							<td>${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}</td>
							<td>${oaTask.relationName}</td>
							<td><fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/></td>
							<td>${fns:getDictLabel(oaTask.levelType, 'level_type', '')}</td>
							<td>${oaTask.schedule}</td>
							<td>${oaTask.ownBy.name}</td>
							<td>${fns:getDictLabel(oaTask.status, 'task_status', '')}</td>
							<td>${oaTask.createBy.name}</td>
							<td><fmt:formatDate value="${oaTask.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="oa:oaTask:view">
									<a href="#" onclick="openDialogView('查看任务', '${ctx}/oa/oaTask/view?id=${oaTask.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>