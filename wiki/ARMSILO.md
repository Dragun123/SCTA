"Retaliator": Tech 3 Nuclear Missile Launcher
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Retaliator unit icon" src="icons/units/ARMSILO_icon.png" />Retaliator<br />Tech 3 Nuclear Missile Launcher
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
            <td><code>armsilo</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T3.png" title="Tech 3" /> 3</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 2300</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>ExperimentalStructure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 52134</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 1010</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>178453 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr>
            <td align="right"><strong>Build rate:</strong></td>
            <td><img src="icons/build.png" title="Build" /> 2160</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>22</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Retaliator" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 3 nuclear missile launcher unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Has a counted projectile weapon that needs manually controlling">Manual Launch</span>
* <span title="Has a death weapon">Volatile</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 29:44 ‒ <img src="icons/energy.png" title="Energy" /> 29/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by <a href="ARMACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 18:35 ‒ <img src="icons/energy.png" title="Energy" /> 47/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by <a href="ARMACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 14:52 ‒ <img src="icons/energy.png" title="Energy" /> 58/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by <a href="ARMACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 4:57:25 ‒ <img src="icons/energy.png" title="Energy" /> 3/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 1:14:21 ‒ <img src="icons/energy.png" title="Energy" /> 12/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<tr>
<td><img float="left" src="icons/orders/silo-build-nuke.png" title="Build Strategic Missile
Right-click to toggle Auto-Build" /></td>
<td><img float="left" src="icons/orders/launch-nuke.png" title="Launch Strategic Missile" /></td>
<td><img float="left" src="icons/orders/pause.png" title="Pause Construction
Pause/unpause current construction order" /></td>
</table>

### Weapons
<details>
<summary>NUCLEAR_MISSILE</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>9000 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>9000 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>15</td>
        </tr>
        <tr>
            <td align="right"><strong>Outer damage:</strong></td>
            <td>2500</td>
        </tr>
        <tr>
            <td align="right"><strong>Outer radius:</strong></td>
            <td>30</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Nuke</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>20000</td>
        </tr>
        <tr>
            <td align="right"><strong>Min range:</strong></td>
            <td>0</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 1.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
        <tr>
            <td align="right"><strong>Projectile storage:</strong></td>
            <td>0/5</td>
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
            <td>1000</td>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH3">TECH3</a> · <a href="_categories.SILO">SILO</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
