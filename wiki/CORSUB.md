"Snake": Tech 1 Submarine
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Snake unit icon" src="icons/units/CORSUB_icon.png" />Snake<br />Tech 1 Submarine
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
            <td><code>corsub</code></td>
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
            <td><img src="icons/health.png" title="Health" /> 590</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 3902</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 720</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>9729</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>8</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>8</td>
        </tr>
        <tr>
            <td align="right"><strong>Sonar radius:</strong></td>
            <td>20</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_SurfacingSub</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Movement speed:</strong></td>
            <td>4.4</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Snake" is a CORE submarine unit included in *SCTATest*.
It is classified as a tech 1 submarine unit. It has no defined build description, and no categories to define common builders.

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
* <img src="icons/time.png" title="Time" /> 01:37 ‒ <img src="icons/energy.png" title="Energy" /> 40/s ‒ <img src="icons/mass.png" title="Mass" /> 7/s — Built by <a href="CORSY">Tech 1 Produces Ships</a>

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
<td><img float="left" src="icons/orders/dive.png" title="Surface/Dive Toggle
Right-click to toggle auto-surface" /></td>
</table>

### Weapons
<details>
<summary>CORE_TORPEDO</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Naval)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>120 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>360 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>30</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 3.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
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
<td>Categories : <a href="_categories.CORE">CORE</a> · <a href="_categories.TECH1">TECH1</a> · <a href="_categories.MOBILE">MOBILE</a> · <a href="_categories.ANTINAVY">ANTINAVY</a> · <a href="_categories.NAVAL">NAVAL</a>
