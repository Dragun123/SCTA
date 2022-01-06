"Stunner": Tech 2 EMP Missile Launcher
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Stunner unit icon" src="icons/units/ARMEMP_icon.png" />Stunner<br />Tech 2 EMP Missile Launcher
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
            <td><code>armemp</code></td>
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
            <td><img src="icons/health.png" title="Health" /> 1500</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 24000</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 2000</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>60000 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr>
            <td align="right"><strong>Build rate:</strong></td>
            <td><img src="icons/build.png" title="Build" /> 10</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>16</td>
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

"Stunner" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 2 emp missile launcher unit. It has no defined build description.<error:buildable unit with no build description>

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
* <span title="Can inflict 'stun'">EMP Weapon</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 10:00 ‒ <img src="icons/energy.png" title="Energy" /> 40/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by <a href="ARMACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 06:15 ‒ <img src="icons/energy.png" title="Energy" /> 64/s ‒ <img src="icons/mass.png" title="Mass" /> 5/s — Built by <a href="ARMACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 05:00 ‒ <img src="icons/energy.png" title="Energy" /> 80/s ‒ <img src="icons/mass.png" title="Mass" /> 7/s — Built by <a href="ARMACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 1:40:00 ‒ <img src="icons/energy.png" title="Energy" /> 4/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 25:00 ‒ <img src="icons/energy.png" title="Energy" /> 16/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
<tr>
<td><img float="left" src="icons/orders/silo-build-nuke.png" title="Build Strategic Missile
Right-click to toggle Auto-Build" /></td>
<td><img float="left" src="icons/orders/launch-nuke.png" title="Launch Strategic Missile" /></td>
<td><img float="left" src="icons/orders/pause.png" title="Pause Construction
Pause/unpause current construction order" /></td>
</table>

### Weapons
<details>
<summary>EMBMSSL</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>30 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>30 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage to shields:</strong></td>
            <td>3000</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>15</td>
        </tr>
        <tr>
            <td align="right"><strong>Outer damage:</strong></td>
            <td>20</td>
        </tr>
        <tr>
            <td align="right"><strong>Outer radius:</strong></td>
            <td>25</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Nuke</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>500</td>
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
        <tr>
            <td align="right"><strong>Buffs:</strong></td>
            <td><code>STUN</code></td>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH2">TECH2</a> · <a href="_categories.SILO">SILO</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
