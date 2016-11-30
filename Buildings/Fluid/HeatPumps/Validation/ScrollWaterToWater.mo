within Buildings.Fluid.HeatPumps.Validation;
model ScrollWaterToWater
  "Test model for scroll water to water heat pump"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.47
    "Nominal mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.47
    "Nominal mass flow rate on the evaporator side";

  parameter Modelica.SIunits.MassFlowRate Flow_Source = 0.79
    "Mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate Flow_Load = 0.47
    "Mass flow rate on the evaporator side";

  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2, nPorts=1) "Source side sink"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-40})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1, nPorts=1) "Load side sink"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={58,20})));
  Modelica.Blocks.Sources.Constant          isOn(k=1)
    "Heat pump control signal"
    annotation (Placement(transformation(extent={{-52,-26},{-40,-14}})));
  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare package Medium = Medium1,
    m_flow=Flow_Load,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Load side flow source"
    annotation (Placement(transformation(extent={{-66,10},{-46,30}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium2,
    m_flow=Flow_Source,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source side flow source"
    annotation (Placement(transformation(extent={{68,-16},{48,4}})));
  Modelica.Blocks.Sources.RealExpression mLoa(y=Flow_Load)
    "Load side mass flwo rate"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.Blocks.Sources.RealExpression mSou(y=Flow_Source)
    "Source side mass flow rate"
    annotation (Placement(transformation(extent={{100,-8},{80,12}})));
  Buildings.Fluid.HeatPumps.ScrollWaterToWater heaPum(
    redeclare package Medium1 =
        Medium1,
    redeclare package Medium2 =
        Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A,
    UACon=4400,
    UAEva=4400,
    volRat=2,
    v_flow=0.003,
    leaCoe=0.01,
    etaEle=0.696,
    PLos=500,
    dTSup=10,
    enable_variable_speed=false) "Scroll water to water heat pump"
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp yLoa(
    height=20,
    duration=750,
    offset=293.15,
    startTime=250) "Load side fluid temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Ramp ySou(
    height=20,
    duration=750,
    offset=283.15,
    startTime=0) "Source side fluid temperature"
    annotation (Placement(transformation(extent={{100,-38},{80,-18}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temLoa_in(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    tau=0.01) "Load side inlet temperature sensor"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temLoa_out(
    redeclare package Medium = Medium1,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    m_flow_nominal=m1_flow_nominal) "Load side outlet temperature sensor"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSou_in(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Source side inlet temperature sensor"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSou_out(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Source side outlet temperature sensor"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{79,2},{68,2}},                 color={0,0,127}));
  connect(mLoa.y, loa.m_flow_in) annotation (Line(points={{-79,28},{-72,28},{
          -66,28}},      color={0,0,127}));
  connect(yLoa.y, loa.T_in) annotation (Line(points={{-79,0},{-74,0},{-74,24},{
          -68,24}},      color={0,0,127}));
  connect(ySou.y, sou.T_in) annotation (Line(points={{79,-28},{72,-28},{72,-2},
          {70,-2}}, color={0,0,127}));
  connect(isOn.y, heaPum.N) annotation (Line(points={{-39.4,-20},{-32,-20},{-32,
          3},{-12,3}}, color={0,0,127}));
  connect(heaPum.port_a2, temSou_in.port_a)
    annotation (Line(points={{10,-6},{20,-6}}, color={0,127,255}));
  connect(sou.ports[1], temSou_in.port_b)
    annotation (Line(points={{48,-6},{40,-6}}, color={0,127,255}));
  connect(temLoa_out.port_b, sin1.ports[1])
    annotation (Line(points={{40,20},{44,20},{48,20}}, color={0,127,255}));
  connect(heaPum.port_b1, temLoa_out.port_a)
    annotation (Line(points={{10,6},{20,6},{20,20}}, color={0,127,255}));
  connect(heaPum.port_a1, temLoa_in.port_b) annotation (Line(points={{-10,6},{
          -16,6},{-16,20},{-20,20}}, color={0,127,255}));
  connect(temLoa_in.port_a, loa.ports[1])
    annotation (Line(points={{-40,20},{-46,20}}, color={0,127,255}));
  connect(heaPum.port_b2, temSou_out.port_b)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-40}}, color={0,127,255}));
  connect(temSou_out.port_a, sin2.ports[1])
    annotation (Line(points={{-40,-40},{-60,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/ScrollWaterToWater.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatPumps.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.ScrollWaterToWater</a> heat pump model.
</p>
<p>
The heat pump power, condenser heat transfer rate and evaporator heat transfer
rate are calculated for given water temperatures and flow rates on the
evaporator and condenser sides.
</p>
</html>", revisions="<html>
<ul>
<li>
October 18, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;
