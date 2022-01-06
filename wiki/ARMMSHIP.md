"Ranger": Tech 2 Missile Ship
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Ranger unit icon" src="icons/units/ARMMSHIP_icon.png" />Ranger<br />Tech 2 Missile Ship
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
            <td><code>armmship</code></td>
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
            <td><img src="icons/health.png" title="Health" /> 1600</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 7804</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 2348</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>22317</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>16</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>4</td>
        </tr>
        <tr>
            <td align="right"><strong>Radar radius:</strong></td>
            <td>80</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_Water</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Movement speed:</strong></td>
            <td>2</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>3 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Ranger" is an ARM naval unit included in *SCTATest*.
It is classified as a tech 2 missile ship unit. It has no defined build description, and no categories to define common builders.

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Can shoot aircraft, including high-altitude air">Anti-Air</span>
* <span title="Can see blips of units not seen by vision that are on or above water">Radar</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 01:51 ‒ <img src="icons/energy.png" title="Energy" /> 70/s ‒ <img src="icons/mass.png" title="Mass" /> 21/s — Built by <a href="ARMASY">Tech 2 Produces Ships</a>

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/move.png" title="Move" /></td>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/patrol.png" title="Patrol" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/guard.png" title="Assist" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
</table>

### Weapons
<details>
<summary>SCABGUN</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Projectile</code><br />(Anti-tactical)</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>30 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage instances:</strong></td>
            <td>2 projectiles</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>45</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 1.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>ARMMSHIP_ROCKET</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><error:Weapon hits high alt air and other stuff></td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>4000 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>2000 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
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
            <td align="right"><strong>Max range:</strong></td>
            <td>125</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 0.5s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
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
            <td>100</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>5</td>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH2">TECH2</a> · <a href="_categories.MOBILE">MOBILE</a> · <a href="_categories.ANTIAIR">ANTIAIR</a> · <a href="_categories.NAVAL">NAVAL</a> · <a href="_categories.SILO">SILO</a>
