within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal4_n
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n phase[4];
  annotation (Icon(graphics={                Polygon(
          points={{-100,110},{-100,70},{100,70},{100,110},{-100,110}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,-10},{-100,-50},{100,-50},{100,-10},{-100,-10}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,50},{-100,10},{100,10},{100,50},{-100,50}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,-70},{-100,-110},{100,-110},{100,-70},{-100,-70}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Terminal4_n;
