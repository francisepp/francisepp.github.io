<%@page import="entity.Orders, serviceImpl.OrdersDAOImpl"%>
<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<!--Stylesheets-->
<link href="<%=path%>/css/jquery.modal.css" type="text/css" rel="stylesheet" />
<link href="<%=path%>/css/jquery.modal.theme-xenon.css" type="text/css" rel="stylesheet" />
<link href="<%=path%>/css/jquery.modal.theme-atlant.css" type="text/css" rel="stylesheet" />
<!--jQuery-->
<script type="text/javascript" src="<%=path%>/js/jquery-latest.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery.modal.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	
	$(".list").each(function() {
		var alink = $(this).children().eq(8).children();//eq(8)获得书目信息每一行的第9个选项，即“订购”
		alink.bind("click", function() {//给“订购”添加点击事件
			var isbn = alink.parent().parent().children("td").get(2).innerHTML;//get(2)获得对应行的第3个选项的内容，即isbn
			$.ajax({//在后台进行数据库连接请求
				type: "post",
	    		url: "Books_ordersreview.action?isbn="+isbn+"&req=0",//请求路径，通过isbn来查重
	    		success: function(data){
	                if (data == "yes") {
	                	(function() { //弹框提示用户是否继续订购订单
					        modal({
					            type: 'confirm',
					            title: '提示',
					            text: '订单中已订购过这本书，是否继续订购？',
					            callback: function(result) {
					            	if (!result) {
					            		return;
					            	}
					            	window.location.href = "Books_ordersreview.action?isbn="+isbn+"&req=1";
					            }
					        });
					    })();
	                } else if (data == "no") {
						window.location.href = "Books_ordersreview.action?isbn="+isbn+"&req=1";
	                }
				}, 
				error: function(){
					alert("请求错误！");
				}
			});
		});
	});

    //prompt
    //找到a标签且id为prompt的元素
    $('a#prompt').click(function() {
        modal({
            type: 'prompt',
            title: '查找书目',
            text: '输入 <b>书名</b> 或 <b>ISBN</b> 或 <b>作者</b> 查找书目:',
            callback: function(result) {
            	if (!result) {
            		return;
            	}
            	// 如果输入了查询，则跳转页面
            	window.location.href = "Books_booksquery2.action?result=" + result;
            }
        });
    });
});
</script>
<link rel="stylesheet" type="text/css" href="<%=path%>/css/default.css" />
<style type="text/css">
* {
	background: none repeat scroll 0 0 transparent;
	border: 0 none;
	margin: 0;
	padding: 0;
	vertical-align: baseline;
	font-family: 微软雅黑;
	overflow: hidden;
}

#navi {
	width: 100%;
	position: relative;
	word-wrap: break-word;
	border-bottom: 1px solid #065FB9;
	margin: 0;
	padding: 0;
	height: 40px;
	line-height: 40px;
	vertical-align: middle;
	background-image: -moz-linear-gradient(top, #EBEBEB, #BFBFBF);
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #EBEBEB),
		color-stop(1, #BFBFBF) );
}

#naviDiv {
	font-size: 14px;
	color: #333;
	padding-left: 10px;
}

#tips {
	margin-top: 10px;
	width: 100%;
	height: 40px;
}

#buttonGroup {
	padding-left: 10px;
	float: left;
	height: 35px;
}

.button {
	float: left;
	margin-right: 10px;
	padding-left: 10px;
	padding-right: 10px;
	font-size: 14px;
	width: 70px;
	height: 30px;
	line-height: 30px;
	vertical-align: middle;
	text-align: center;
	cursor: pointer;
	border-color: #77D1F6;
	border-width: 1px;
	border-style: solid;
	border-radius: 6px 6px;
	-moz-box-shadow: 2px 2px 4px #282828;
	-webkit-box-shadow: 2px 2px 4px #282828;
	background-image: -moz-linear-gradient(top, #EBEBEB, #BFBFBF);
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #EBEBEB),
		color-stop(1, #BFBFBF) );
}

#mainContainer {
	padding-left: 10px;
	padding-right: 10px;
	text-align: center;
	width: 98%;
	font-size: 12px;
}

a {
	font-weight: bold;
}

.r {
	text-align: right;
	padding-right: 28px;
}
</style>
<body>
	<div id="navi">
		<div id='naviDiv'>
			<span><img src="../images/arror.gif" width="7" height="11"
				border="0" alt=""> </span>&nbsp;书目管理&nbsp; <span><img
					src="../images/arror.gif" width="7" height="11" border="0" alt="">
			</span>&nbsp;<a href="<%=path%>/books/Books_booksquery.action">书目列表</a>&nbsp;
		</div>
	</div>
	<div id="tips">
		<div id="buttonGroup">
			<div class="button"
				onmouseout="this.style.backgroundColor='';this.style.fontWeight='normal'"
				onmouseover="this.style.backgroundColor='#77D1F6';this.style.fontWeight='bold'">
				<a href="<%=path%>/books/Books_add.jsp">添加书目</a>
			</div>
			<div class="button"
				onmouseout="this.style.backgroundColor='';this.style.fontWeight='normal'"
				onmouseover="this.style.backgroundColor='#77D1F6';this.style.fontWeight='bold'">
				<a href="#" id="prompt">查找书目</a>
			</div>
		</div>
	</div>
	<div id="mainContainer">
		<!-- 从session中获取书目集合 -->
		<table class="default" width="100%">
			<col width="14%">
			<col width="18%">
			<col width="14%">
			<col width="14%">
			<col width="10%">
			<col width="8%">
			<col width="10%">
			<col width="6%">
			<col width="6%">
			<tr class="title">
				<td>书号</td>
				<td>书名</td>
				<td>ISBN</td>
				<td>出版社</td>
				<td>作者</td>
				<td>价格</td>
				<td>出版日期</td>
				<td>操作1</td>
				<td>操作2</td>
			</tr>

			<!-- 遍历开始 -->
			<s:iterator value="#session.books_list" var="book">
				<tr class="list">
					<td><s:property value="#book.bid" /></td>
					<td><a href="<%=path%>/books/Books_booksmodify.action?bid=<s:property value="#book.bid" />">
						<s:property value="#book.bookname" /> </a></td>
					<td><s:property value="#book.isbn" /></td>
					<td><s:property value="#book.publishing" /></td>
					<td><s:property value="#book.author" /></td>
					<td class="r">¥<s:property value="#book.price" /></td>
					<td><s:property value="#book.date" /></td>
					<td><a href="<%=path%>/books/Books_booksdelete.action?bid=<s:property value="#book.bid"/>" onclick="javascript: return confirm('真的要删除吗？');">删除</a></td>
				 	<td><a href="#" id="order">订购</a></td> 
				</tr>
			</s:iterator>
			<!-- 遍历结束 -->
		</table>
	</div>
</body>
</html>