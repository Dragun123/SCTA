"Storm": Tech 1 Rocket Kbot
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Storm unit icon" src="icons/units/CORSTORM_icon.png" />Storm<br />Tech 1 Rocket Kbot
            </th>
        </tr>
    </thead>
    <tbody>
        <tr><td align="center" colspan="2">Note: Several units have stats defined at the<br />start of the game based on the stats of others.</td></tr>
        <tr>
            <td align="right"><strong>Source:</strong></td>
            <td><a href="SCTATest">SCTATest</a></td>
        </tr>
        <tr>
            <td align="right"><strong>Unit ID:</strong></td>
            <td><code>corstorm</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>CORE</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T1.png" title="Tech 1" /> 1</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 620</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 985</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 160</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>1969</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>14</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_Land</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Movement speed:</strong></td>
            <td>2.4</td>
        </tr>
        <tr>
            <td align="right"><strong>Transport class:</strong></td>
            <td><img src="icons/attached.png" title="Attached" /> Small</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Storm" is a CORE land unit included in *SCTATest*.
It is classified as a tech 1 rocket kbot unit. It has no defined build description, and no categories to define common builders.

<details>
<summary>Contents</summary>

1. – <a href="#construction">Construction</a>
2. – <a href="#order-capabilities">Order capabilities</a>
3. – <a href="#weapons">Weapons</a>
</details>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 00:19 ‒ <img src="icons/energy.png" title="Energy" /> 50/s ‒ <img src="icons/mass.png" title="Mass" /> 8/s — Built by <a href="CORLAB">Tech 1 Produces Kbots</a>

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/move.png" title="Move" /></td>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/patrol.png" title="Patrol" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/guard.png" title="Assist" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
<tr>
<td><img float="left" src="icons/orders/load.png" title="Call Transport
Load into or onto another unit" /></td>
</table>

### Weapons
<details>
<summary>CORKBOT_ROCKET</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><error:Weapon hits high alt air and other stuff></td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>40 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>100 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>1</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>25</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 2.5s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>DeathWeapon</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>50</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>3</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>


<table align=center>
<td>Categories : <a href="_categories.CORE">CORE</a> · <a href="_categories.TECH1">TECH1</a> · <a href="_categories.MOBILE">MOBILE</a> · <a href="_categories.DIRECTFIRE">DIRECTFIRE</a> · <a href="_categories.LAND">LAND</a> · <a href="_categories.SILO">SILO</a>
