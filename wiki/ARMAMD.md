"Protector": Tech 3 Anti Missile Defense System
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Protector unit icon" src="icons/units/ARMAMD_icon.png" />Protector<br />Tech 3 Anti Missile Defense System
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
            <td><code>armamd</code></td>
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
            <td><img src="icons/health.png" title="Health" /> 780</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 88000</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 1437</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>95678 (<a href="#construction">Details</a>)</td>
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

"Protector" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 3 anti missile defense system unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#construction">Construction</a>
2. – <a href="#order-capabilities">Order capabilities</a>
3. – <a href="#weapons">Weapons</a>
</details>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 15:56 ‒ <img src="icons/energy.png" title="Energy" /> 92/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by <a href="ARMACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 09:57 ‒ <img src="icons/energy.png" title="Energy" /> 147/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by <a href="ARMACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 07:58 ‒ <img src="icons/energy.png" title="Energy" /> 184/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by <a href="ARMACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 2:39:27 ‒ <img src="icons/energy.png" title="Energy" /> 9/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 39:51 ‒ <img src="icons/energy.png" title="Energy" /> 37/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<tr>
<td><img float="left" src="icons/orders/silo-build-tactical.png" title="Build Missile
Right-click to toggle Auto-Build" /></td>
<td><img float="left" src="icons/orders/pause.png" title="Pause Construction
Pause/unpause current construction order" /></td>
</table>

### Weapons
<details>
<summary>AMD_ROCKET</summary>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH3">TECH3</a> · <a href="_categories.SILO">SILO</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
