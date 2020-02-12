within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialDistribution2Pipe
  "Partial model for two-pipe distribution network"
  extends PartialDistribution;
  replaceable model Model_pipDis = Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Model for distribution pipe";
  parameter Integer iConPreRel(min=0, max=nCon) = 0
    "Index of the connection where the pressure drop is sensed (0 for no sensor)"
    annotation(Dialog(tab="General"), Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal[nCon]
    "Nominal mass flow rate in the distribution line before each connection"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
    "Nominal mass flow rate in each connection line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mEnd_flow_nominal
    "Nominal mass flow rate in the end of the distribution line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-220,-80}, {-180,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation( extent={{90,-70},{110,-50}}),
      iconTransformation(extent={{180,-80},{ 220,-40}})));
  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference", final displayUnit="Pa") if iConPreRel > 0
    "Pressure difference at given location (sensed)"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{200,50}, {220,70}})));
  // COMPONENTS
  replaceable BaseClasses.PartialConnection2Pipe con[nCon](
    redeclare each final package Medium = Medium,
    final have_dpSen={i==iConPreRel for i in 1:nCon},
    final mDis_flow_nominal=mDis_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Model_pipDis pipEnd(
    final m_flow_nominal=mEnd_flow_nominal)
    "Pipe representing the end of the distribution line (after last connection)"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(con.port_bCon, ports_bCon)
    annotation (Line(points={{0,10},{0,40},{-80,
          40},{-80,100}}, color={0,127,255}));
  connect(ports_aCon, con.port_aCon)
    annotation (Line(points={{80,100},{80,40},
          {6,40},{6,10}}, color={0,127,255}));
  // Connecting outlets to inlets for all instances of connection component
  if nCon >= 2 then
    for i in 2:nCon loop
      connect(con[i - 1].port_bDisSup, con[i].port_aDisSup);
      connect(con[i - 1].port_aDisRet, con[i].port_bDisRet);
    end for;
  end if;
  connect(port_aDisSup, con[1].port_aDisSup)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_bDisRet, con[1].port_bDisRet)
    annotation (Line(points={{-100,-60},{-40,-60},{-40,-6},{-10,-6}},
                                        color={0,127,255}));
  connect(con[nCon].port_aDisRet, port_aDisRet)
    annotation (Line(points={{10,-6},{40,-6},{40,-60},{100,-60}},
                                       color={0,127,255}));
    connect(con[nCon].port_bDisSup, pipEnd.port_a)
      annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
    connect(pipEnd.port_b, port_bDisSup)
      annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  if iConPreRel > 0 then
    connect(con[iConPreRel].dp, dp)
      annotation (Line(points={{11,4},{20,4},{20,60},{120,60}},
          color={0,0,127}));
  end if;
  annotation (
    defaultComponentName="dis",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-6,-200},{6,200}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=90),
        Rectangle(
          extent={{-53,4},{53,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-120,47},
          rotation=90),
        Rectangle(
          extent={{-44,4},{44,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={120,56},
          rotation=90),
        Rectangle(
          extent={{-6,-200},{6,200}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,-60},
          rotation=90),
        Rectangle(
          extent={{-27,4},{27,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={120,-39},
          rotation=90)}),
    Diagram( coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution2Pipe;
