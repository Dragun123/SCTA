"Lancet": Tech 2 Torpedo Bomber
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Lancet unit icon" src="icons/units/ARMLANCE_icon.png" />Lancet<br />Tech 2 Torpedo Bomber
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
            <td><code>armlance</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T2.png" title="Tech 2" /> 2</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 370</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Light</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 6438</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 378</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>14096</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>22</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>14</td>
        </tr>
        <tr>
            <td align="right"><strong>Sonar radius:</strong></td>
            <td>30</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_Air</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Movement speed:</strong></td>
            <td>15</td>
        </tr>
        <tr>
            <td align="right"><strong>Fuel:</strong></td>
            <td><img src="icons/fuel.png" title="Fuel" /> 123:27:24</td>
        </tr>
        <tr>
            <td align="right"><strong>Elevation:</strong></td>
            <td>17</td>
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

"Lancet" is an ARM aircraft unit included in *SCTATest*.
It is classified as a tech 2 torpedo bomber unit. It has no defined build description, and no categories to define common builders.

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Has a weapon that can target things immersed in water">Torpedoes</span>
* <span title="Can see blips of units not seen by vision that are on or below water">Sonar</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 01:10 ‒ <img src="icons/energy.png" title="Energy" /> 91/s ‒ <img src="icons/mass.png" title="Mass" /> 5/s — Built by <a href="ARMAAP">Tech 2 Produces Aircraft</a>
* <img src="icons/time.png" title="Time" /> 01:10 ‒ <img src="icons/energy.png" title="Energy" /> 91/s ‒ <img src="icons/mass.png" title="Mass" /> 5/s — Built by <a href="ARMPLAT">Tech 3 Builds Seaplanes</a>

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
<td><img float="left" src="icons/orders/dock.png" title="Dock
Recall aircraft to nearest air staging facility for refueling and repairs" /></td>
</table>

### Weapons
<details>
<summary>ARMAIR_TORPEDO</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Naval)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>60 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>750 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>42</td>
        </tr>
        <tr>
            <td align="right"><strong>Min range:</strong></td>
            <td>4</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 12.5s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>DeathImpact</summary>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH2">TECH2</a> · <a href="_categories.MOBILE">MOBILE</a> · <a href="_categories.ANTINAVY">ANTINAVY</a> · <a href="_categories.AIR">AIR</a> · <a href="_categories.BOMBER">BOMBER</a>
