within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model Supervisory "Energy transfer station supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.TemperatureDifference THys
    "Temperature hysteresis";
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(final unit="1/K") = 0.01
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0) = 60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
         or  controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMin = 0.01
    "Minimum control output"
    annotation (Dialog(group="PID controller"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon
    "Condenser to ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60}, {140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva
    "Evaporator to ambient loop isolation valve control signal"
    annotation (Placement(
    transformation(extent={{100,-90},{140,-50}}), iconTransformation(
      extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{100,30},
    {140,70}}),iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yColRej
    "Enabled signal for full cold rejection to ambient loop"
    annotation (Placement(transformation(extent={{100,-30},{140,10}}),
      iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaRej
    "Enabled signal for full heat rejection to ambient loop"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  HotSide conHotSid(final THys=THys)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(final THys=THys)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-120,50},{-20,
          50},{-20,48},{-12,48}}, color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-120,20},{-20,
          20},{-20,44},{-12,44}}, color={0,0,127}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-120,-40},{-24,
          -40},{-24,-72},{-12,-72}}, color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-120,-70},{-28,
          -70},{-28,-76},{-12,-76}}, color={0,0,127}));
  connect(conColSid.yRej, yColRej) annotation (Line(points={{12,-66},{80,-66},{
          80,-10},{120,-10}}, color={255,0,255}));
  connect(conHotSid.yRej, yHeaRej) annotation (Line(points={{12,54},{20,54},{20,
          20},{120,20}}, color={255,0,255}));
  connect(TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-120,-10},{-20,
          -10},{-20,-64},{-12,-64}}, color={0,0,127}));
  connect(THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-120,80},{
          -20,80},{-20,56},{-12,56}}, color={0,0,127}));
  connect(conHotSid.yIso,yIsoCon)  annotation (Line(points={{12,46},{14,46},{14,
          -40},{120,-40}}, color={0,0,127}));
  connect(conColSid.yIso,yIsoEva)
    annotation (Line(points={{12,-74},{80,-74},{80,-70},{120,-70}}, color={0,0,127}));
  connect(yHea, yHea)
    annotation (Line(points={{120,80},{120,80}}, color={255,0,255}));
  connect(conColSid.yHeaCoo, yCoo) annotation (Line(points={{12,-62},{60,-62},{60,
          50},{120,50}}, color={255,0,255}));
  connect(conHotSid.yHeaCoo, yHea) annotation (Line(points={{12,58},{20,58},{20,
          80},{120,80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName="conSup",
        Documentation(info="<html>
<p>
The block implements the control sequence for the ETS chilled water and 
heating water circuits.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 10, 2019, by Hagar Elarga:<br/>
Added the documentation. 
</li>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Removed the tank minimum charging flow signal because the primary pumps are constant speed.
</li>
</ul>
</html>"));
end Supervisory;
