within Buildings.Controls.OBC.FDE.DOAS;
block EnergyWheel
  "This block commands the energy recovery wheel and associated bypass dampers."

  parameter Real recSet(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=7
   "Energy recovery set point.";
  parameter Real recSetDelay(
    final unit="s",
    final quantity="Time")=300
    "Minimum delay after OAT/RAT delta falls below set point.";
  parameter Real kGain(
    final unit="1")=0.00001
    "PID loop gain value.";
  parameter Real conTi(
    final unit="s")=0.00025
    "PID time constant of integrator.";

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanProof
    "True when the supply fan is proven on."
      annotation (Placement(transformation(extent={{-142,60},{-102,100}}),
        iconTransformation(extent={{-120,56},{-80,96}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput oaT
    "Outside air temperature sensor."
      annotation (Placement(transformation(extent={{-142,-38},{-102,2}}),
        iconTransformation(extent={{-122,-34},{-82,6}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput raT
    "Return air temperature sensor."
      annotation (Placement(transformation(extent={{-142,0},{-102,40}}),
        iconTransformation(extent={{-122,6},{-82,46}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ecoMode
    "True when economizer mode is active."
      annotation (Placement(transformation(extent={{-142,30},{-102,70}}),
        iconTransformation(extent={{-128,30},{-88,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput erwT
    "Energy recovery wheel supply air temperature."
      annotation (Placement(transformation(extent={{-142,-74},{-102,-34}}),
        iconTransformation(extent={{-124,-74},{-84,-34}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput supPrimSP
    "Primary supply air temperature set point."
      annotation (Placement(transformation(extent={{-142,-106},{-102,-66}}),
        iconTransformation(extent={{-122,-108},{-82,-68}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput erwStart
    "Command to start the energy recovery wheel."
      annotation (Placement(transformation(extent={{102,0},{142,40}}),
        iconTransformation(extent={{86,-12},{126,28}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput erwSpeed
    "Energy recovery wheel speed command."
      annotation (Placement(transformation(extent={{102,-96},{142,-56}}),
        iconTransformation(extent={{82,-96},{122,-56}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput bypDam
    "Bypass damper command; true when commanded full open."
      annotation (Placement(transformation(extent={{102,46},{142,86}}),
        iconTransformation(extent={{84,46},{124,86}})));

  Buildings.Controls.OBC.CDL.Continuous.Add difference(
    final k2=-1)
      annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conRecovery(
    k=recSet)
      "Recovery set point."
        annotation (Placement(transformation(extent={{-62,-46},{-42,-26}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les
    annotation (Placement(transformation(extent={{-26,-38},{-6,-18}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=recSetDelay,
    delayOnInit=true)
      "Recovery set point delay before disabling energy wheel."
        annotation (Placement(transformation(extent={{2,-38},{22,-18}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    annotation (Placement(transformation(extent={{62,10},{82,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-26,40},{-6,60}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    k=kGain,
    Ti=conTi,
    reverseAction=true)
    annotation (Placement(transformation(extent={{-90,-64},{-70,-44}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(k=kGain, Ti=conTi)
    annotation (Placement(transformation(extent={{-90,-94},{-70,-74}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-62,-78},{-42,-58}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{66,-86},{86,-66}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(k=0)
    annotation (Placement(transformation(extent={{30,-94},{50,-74}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-64,56},{-44,76}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{62,56},{82,76}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{34,40},{54,60}})));

equation
  connect(difference.y, abs.u) annotation (Line(points={{-68,0},{-64,0}},
                    color={0,0,127}));
  connect(difference.u1, raT) annotation (Line(points={{-92,6},{-96,6},{-96,20},
          {-122,20}}, color={0,0,127}));
  connect(difference.u2, oaT) annotation (Line(points={{-92,-6},{-96,-6},{-96,-18},
          {-122,-18}}, color={0,0,127}));
  connect(abs.y, gre.u1)
    annotation (Line(points={{-40,0},{-28,0}}, color={0,0,127}));
  connect(gre.y, lat.u)
    annotation (Line(points={{-4,0},{28,0}},color={255,0,255}));
  connect(conRecovery.y, gre.u2) annotation (Line(points={{-40,-36},{-32,-36},{-32,
          -8},{-28,-8}}, color={0,0,127}));
  connect(conRecovery.y, les.u2)
    annotation (Line(points={{-40,-36},{-28,-36}}, color={0,0,127}));
  connect(abs.y, les.u1) annotation (Line(points={{-40,0},{-36,0},{-36,-28},{-28,
          -28}}, color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-4,-28},{0,-28}}, color={255,0,255}));
  connect(truDel.y, lat.clr) annotation (Line(points={{24,-28},{26,-28},{26,-6},
          {28,-6}}, color={255,0,255}));
  connect(lat.y, and3.u3)
    annotation (Line(points={{52,0},{56,0},{56,12},{60,12}},
                                             color={255,0,255}));
  connect(not1.u, ecoMode)
    annotation (Line(points={{-28,50},{-122,50}}, color={255,0,255}));
  connect(not1.y, and3.u2) annotation (Line(points={{-4,50},{0,50},{0,20},{60,20}},
        color={255,0,255}));
  connect(supFanProof, and3.u1) annotation (Line(points={{-122,80},{8,80},{8,28},
          {60,28}}, color={255,0,255}));
  connect(and3.y, erwStart)
    annotation (Line(points={{84,20},{122,20}},
                                              color={255,0,255}));
  connect(conPID.u_s, erwT)
    annotation (Line(points={{-92,-54},{-122,-54}}, color={0,0,127}));
  connect(erwT, conPID1.u_s) annotation (Line(points={{-122,-54},{-96,-54},{-96,
          -84},{-92,-84}}, color={0,0,127}));
  connect(conPID1.u_m, supPrimSP) annotation (Line(points={{-80,-96},{-98,-96},{
          -98,-86},{-122,-86}}, color={0,0,127}));
  connect(supPrimSP, conPID.u_m) annotation (Line(points={{-122,-86},{-98,-86},{
          -98,-66},{-80,-66}}, color={0,0,127}));
  connect(conPID.y, max.u1) annotation (Line(points={{-68,-54},{-66,-54},{-66,-62},
          {-64,-62}}, color={0,0,127}));
  connect(conPID1.y, max.u2) annotation (Line(points={{-68,-84},{-66,-84},{-66,-74},
          {-64,-74}}, color={0,0,127}));
  connect(max.y, swi.u1)
    annotation (Line(points={{-40,-68},{64,-68}}, color={0,0,127}));
  connect(and3.y, swi.u2) annotation (Line(points={{84,20},{88,20},{88,-58},{56,
          -58},{56,-76},{64,-76}}, color={255,0,255}));
  connect(con0.y, swi.u3)
    annotation (Line(points={{52,-84},{64,-84}}, color={0,0,127}));
  connect(swi.y, erwSpeed)
    annotation (Line(points={{88,-76},{122,-76}}, color={0,0,127}));
  connect(ecoMode, and1.u2) annotation (Line(points={{-122,50},{-94,50},{-94,58},
          {-66,58}}, color={255,0,255}));
  connect(supFanProof, and1.u1) annotation (Line(points={{-122,80},{-94,80},{-94,
          66},{-66,66}}, color={255,0,255}));
  connect(and1.y, or2.u1)
    annotation (Line(points={{-42,66},{60,66}}, color={255,0,255}));
  connect(not2.y, or2.u2) annotation (Line(points={{56,50},{58,50},{58,58},{60,58}},
        color={255,0,255}));
  connect(and3.y, not2.u) annotation (Line(points={{84,20},{88,20},{88,36},{28,36},
          {28,50},{32,50}}, color={255,0,255}));
  connect(or2.y, bypDam)
    annotation (Line(points={{84,66},{122,66}}, color={255,0,255}));
  annotation (defaultComponentName="ERWcon",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
           Text(
            extent={{-88,180},{92,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Text(
          extent={{-94,78},{-50,64}},
          lineColor={28,108,200},
          textString="supFanProof")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 15, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>Energy Recovery Wheel Start/Stop.</h4>
<p>This block commands the ERW to start 
(<code>erwStart</code>) when the DOAS is energized
(<code>supFanProof</code>) and the absolute difference between 
return air temperature (<code>raT</code>) and outside air temperature
(<code>oaT</code>) is greater than the recovery set point 
(<code>recSet</code>). When the DOAS is not energized, economizer
mode is enabled 
(<code>ecoMode</code>), or the RAT/OAT difference falls below the
recovery set point for longer than the recovery set point delay 
(<code>recSetDelay</code>) the ERW will be commanded to stop.</p>
<h4>ERW Speed Control</h4>
<p>The ERW speed 
(<code>erwSpeed</code>) is modulated to  maintain the energy recovery
supply temperature (<code>erwT</code>) at the primary supply air
 temperature set point (<code>supPrimSP</code>).</p>
<h4>Bypass Damper Control</h4>
When the DOAS is energized and in economizer mode or the ERW is stopped, 
the bypass dampers shall be commanded fully open to bypass
(<code>bypDam</code>). When the DOAS is de-energized or the DOAS is 
energized and the ERW is started, the bypass dampers shall be 
commanded closed to bypass.</p>
</html>"));
end EnergyWheel;
