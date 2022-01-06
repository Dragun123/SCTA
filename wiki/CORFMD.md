"Fortitude Missile Defense": Tech 3 Anti Missile Defense System
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Fortitude Missile Defense unit icon" src="icons/units/CORFMD_icon.png" />Fortitude Missile Defense<br />Tech 3 Anti Missile Defense System
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
            <td><code>corfmd</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>CORE</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T3.png" title="Tech 3" /> 3</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 780</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 92321</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 1508</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>96450 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr>
            <td align="right"><strong>Build rate:</strong></td>
            <td><img src="icons/build.png" title="Build" /> 1080</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>10</td>
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

"Fortitude Missile Defense" is a CORE structure unit included in *SCTATest*.
It is classified as a tech 3 anti missile defense system unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Can target strategic missile projectiles">Strategic Missile Defense</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 16:04 ‒ <img src="icons/energy.png" title="Energy" /> 96/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by <a href="CORACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 10:02 ‒ <img src="icons/energy.png" title="Energy" /> 153/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by <a href="CORACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 08:02 ‒ <img src="icons/energy.png" title="Energy" /> 191/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by <a href="CORACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 2:40:45 ‒ <img src="icons/energy.png" title="Energy" /> 10/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 40:11 ‒ <img src="icons/energy.png" title="Energy" /> 38/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
<tr>
<td><img float="left" src="icons/orders/silo-build-tactical.png" title="Build Missile
Right-click to toggle Auto-Build" /></td>
</table>

### Weapons
<details>
<summary>FMD_ROCKET</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Projectile</code><br />(Anti-strategic)</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>30000 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
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
            <td>Once every 0.1s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Projectile storage:</strong></td>
            <td>0/10</td>
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
            <td>2000</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>10</td>
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
<td>Categories : <a href="_categories.CORE">CORE</a> · <a href="_categories.TECH3">TECH3</a> · <a href="_categories.SILO">SILO</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
